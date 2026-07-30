function k8s-up
    set -gx CGROUP_DRIVER systemd
    set -gx CGROUP_ROOT /
    set -gx CONTAINER_RUNTIME_ENDPOINT unix:///var/run/crio/crio.sock
    set -gx ALLOW_PRIVILEGED 1

    set -l IP (__ip)
    echo "Using IP: $IP"
    set -gx DNS_SERVER_IP $IP
    set -gx API_HOST_IP $IP

    sudo iptables -F FORWARD

    set -l k8s $GOPATH/src/k8s.io/kubernetes
    $k8s/hack/install-etcd.sh
    fish_add_path --path --move $k8s/third_party/etcd
    sudo -E $k8s/hack/local-up-cluster.sh
end

function crio-up
    set -l d $GOPATH/src/github.com/cri-o/cri-o
    ns make -C $d
    sudo $d/bin/crio
end

function __ip
    ip route get 1.2.3.4 | cut -d ' ' -f7 | head -n1
end

function k8s-env
    set -gx KUBERUN /var/run/kubernetes
    set -gx KUBECONFIG $KUBERUN/admin.kubeconfig
    fish_add_path --path --move $GOPATH/src/k8s.io/kubernetes/_output/local/bin/linux/amd64

    sudo chown (id -u):(id -g) $KUBERUN $KUBECONFIG

    set -l IP (__ip)
    set -gx KUBE_MASTER_URL $IP
    set -gx KUBE_MASTER_IP $IP
    set -gx KUBE_MASTER $IP
end

function k8s-test
    k8s-env

    set -l k8s $GOPATH/src/k8s.io/kubernetes
    sudo make -C $k8s ginkgo
    sudo make -C $k8s WHAT=test/e2e/e2e.test

    k8s-test-run $argv
end

function k8s-test-run
    k8s-env

    sudo -E $GOPATH/src/k8s.io/kubernetes/_output/bin/e2e.test \
        --provider=local \
        --host=https://$KUBE_MASTER_IP:6443 \
        $argv
end
