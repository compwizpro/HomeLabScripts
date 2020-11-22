sudo tee /etc/kubernetes/kubeadminit.yaml >/dev/null <<EOF
apiVersion: kubeadm.k8s.io/v1beta1
kind: InitConfiguration
bootstrapTokens:
       - groups:
         - system:bootstrappers:kubeadm:default-node-token
         token: y7yaev.9dvwxx6ny4ef8vlq
         ttl: 0s
         usages:
         - signing
         - authentication
nodeRegistration:
  kubeletExtraArgs:
    cloud-provider: external
---
apiVersion: kubeadm.k8s.io/v1beta1
kind: ClusterConfiguration
useHyperKubeImage: false
kubernetesVersion: v1.14.2
networking:
  serviceSubnet: "10.96.0.0/12"
  podSubnet: "10.244.0.0/16"
etcd:
  local:
    imageRepository: "k8s.gcr.io"
    imageTag: "3.3.10"
dns:
  type: "CoreDNS"
  imageRepository: "k8s.gcr.io"
  imageTag: "1.5.0"
EOF

sudo kubeadm init --config /etc/kubernetes/kubeadminit.yaml

sudo mkdir -p $HOME/.kube

sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config

sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml

sudo kubectl -n kube-public get configmap cluster-info -o jsonpath='{.data.kubeconfig}' > discovery.yaml