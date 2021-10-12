function k8s-up
    export CONTAINER_RUNTIME=remote
    export CGROUP_DRIVER=cgroupfs
    export CONTAINER_RUNTIME_ENDPOINT=unix:///var/run/crio/crio.sock
    export ALLOW_PRIVILEGED=1

    set -l IP (__ip)
    echo "Using IP: $IP"
    export DNS_SERVER_IP=$IP
    export API_HOST_IP=$IP

    sudo iptables -F

    cd $GOPATH/src/k8s.io/kubernetes
    hack/install-etcd.sh
    export PATH="$GOPATH/src/k8s.io/kubernetes/third_party/etcd:$PATH"
    sudo -E hack/local-up-cluster.sh
end

function crio-up
    cd $GOPATH/src/github.com/cri-o/cri-o
    ns make
    sudo bin/crio
end

function __ip
    ip route get 1.2.3.4 | cut -d ' ' -f7 | tr -d '[:space:]'
end

function k8s-env
    export KUBE_CONTAINER_RUNTIME=remote
    export KUBERUN=/var/run/kubernetes
    export KUBECONFIG=$KUBERUN/admin.kubeconfig
    export PATH="$GOPATH/src/k8s.io/kubernetes/_output/local/bin/linux/amd64:$PATH"

    sudo chown (id -u):(id -g) $KUBERUN $KUBECONFIG

    set -l IP (__ip)
    export KUBE_MASTER_URL=$IP
    export KUBE_MASTER_IP=$IP
    export KUBE_MASTER=$IP
end

function k8s-test
    k8s-env

    cd $GOPATH/src/k8s.io/kubernetes
    sudo make ginkgo
    sudo make WHAT=test/e2e/e2e.test

    k8s-test-run $argv
end

function k8s-test-run
    k8s-env

    sudo -E _output/bin/e2e.test \
        --provider=local \
        --host=https://$IP:6443 \
        $argv
end
