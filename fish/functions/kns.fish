# Set kubernetes namespace
function kns
    test (count $argv) -eq 1 || begin
        echo "Usage: kns <namespace>" >&2
        return 1
    end
    kubectl config set-context --current --namespace=$argv[1]
end
