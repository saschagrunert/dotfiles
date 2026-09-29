# Remove caches that tools rebuild or download again on demand
function cleanup -d "Clean local build, module and download caches"
    set -l before (df --output=avail -B1 ~ | tail -1)

    go clean -cache -testcache -fuzzcache -modcache
    golangci-lint cache clean
    npm cache clean --force 2>/dev/null
    podman system prune --all --force

    rm -rf ~/.cache/{gopls,goimports,pip,pip-tools,grype,vulnix,hugo_cache} \
        ~/.cargo/registry/{cache,src}

    # Test suites (envtest, the k8s test framework) leave their temp dirs
    # behind. Skip recent ones, a test run could still be using them.
    find ~/.cache/tmpbuild -mindepth 1 -maxdepth 1 -mmin +60 -exec rm -rf {} + 2>/dev/null

    set -l after (df --output=avail -B1 ~ | tail -1)
    echo "Freed "(numfmt --to=iec (math "max(0, $after - $before)"))
end
