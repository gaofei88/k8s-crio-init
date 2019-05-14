# k8s-crio-init
## System: Ubuntu 16.04 LTS
## Pod Network
`kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"`
