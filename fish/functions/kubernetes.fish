function k8s-up
    export CONTAINER_RUNTIME=remote
    export CGROUP_DRIVER=cgroupfs
    export CONTAINER_RUNTIME_ENDPOINT=/var/run/crio/crio.sock
    export ALLOW_PRIVILEGED=1

    set -l IP (hostname --ip-address)
    export DNS_SERVER_IP=$IP
    export API_HOST_IP=$IP

    cd $GOPATH/src/github.com/cri-o/cri-o
    make bin/crio
    sudo bin/crio &

    cd $GOPATH/src/k8s.io/kubernetes
    sudo -E hack/local-up-cluster.sh
end

function k8s-test
    export KUBE_CONTAINER_RUNTIME=remote
    export KUBECONFIG=/var/run/kubernetes/admin.kubeconfig
    export PATH="$GOPATH/src/k8s.io/kubernetes/third_party/etcd $PATH"
    export PATH="$GOPATH/src/k8s.io/kubernetes/_output/local/bin/linux/amd64 $PATH"

    set -l IP (hostname --ip-address)
    export KUBE_MASTER_URL=$IP
    export KUBE_MASTER_IP=$IP
    export KUBE_MASTER=$IP

    cd $GOPATH/src/k8s.io/kubernetes
    sudo make ginkgo
    sudo make WHAT=test/e2e/e2e.test

    sudo -E go run hack/e2e.go \
        --get=true -- --test --provider=local \
        --test_args="-host=https://$IP:6443 \
                     -ginkgo.succinct \
                     -ginkgo.focus $argv"
end
