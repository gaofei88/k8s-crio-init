# install cri-o
sudo modprobe overlay
sudo modprobe br_netfilter

echo | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system

sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:projectatomic/ppa
sudo apt-get update

sudo apt-get install -y cri-o-1.11

sudo mkdir -p /etc/sysconfig
# workaround: use CRIO_NETWORK_OPTIONS to set the registry
echo CRIO_NETWORK_OPTIONS=--registry=docker.io |sudo tee /etc/sysconfig/crio-network

sudo systemctl daemon-reload
sudo systemctl stop crio
sudo systemctl start crio

# install kubeadm
sudo apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo deb http://apt.kubernetes.io/ kubernetes-xenial main | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubeadm kubelet

sudo wget https://gist.githubusercontent.com/haircommander/2c07cc23887fa7c7f083dc61c7ef5791/raw/73e3d27dcd57e7de237c08758f76e0a368547648/cri-o-kubeadm -O /etc/default/kubelet

kubeadm init --pod-network-cidr=10.88.0.0/16
