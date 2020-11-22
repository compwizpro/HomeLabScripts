##Create and apply vsphere.conf in /etc/kubernetes

cd /etc/kubernetes
sudo kubectl create configmap cloud-config --from-file=vsphere.conf --namespace=kube-system

#create your server.yaml file

sudo kubectl create -f cpi-global-secret.yaml

sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/cloud-provider-vsphere/master/manifests/controller-manager/cloud-controller-manager-roles.yaml

sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes/cloud-provider-vsphere/master/manifests/controller-manager/cloud-controller-manager-role-bindings.yaml

sudo kubectl apply -f https://github.com/kubernetes/cloud-provider-vsphere/raw/master/manifests/controller-manager/vsphere-cloud-controller-manager-ds.yaml

#create a csi-vsphere.conf file 

sudo kubectl create secret generic vsphere-config-secret --from-file=csi-vsphere.conf --namespace=kube-system

sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/vsphere-csi-driver/master/manifests/v2.0.0/vsphere-7.0/vanilla/rbac/vsphere-csi-controller-rbac.yaml

sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/vsphere-csi-driver/master/manifests/v2.0.0/vsphere-7.0/vanilla/deploy/vsphere-csi-controller-deployment.yaml

sudo kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/vsphere-csi-driver/master/manifests/v2.0.0/vsphere-7.0/vanilla/deploy/vsphere-csi-node-ds.yaml

#create mongodb-storageclass.yaml

sudo kubectl create -f mongodb-storageclass.yaml

