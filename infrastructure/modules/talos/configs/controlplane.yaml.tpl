machine:
  network:
    hostname: ${hostname}
  nodeLabels:
    topology.kubernetes.io/region: ${cluster_name}
    topology.kubernetes.io/zone: ${node_name}
  kubelet:
    extraArgs:
      rotate-server-certificates: true
    extraMounts:
      - destination: /var/lib/longhorn
        type: bind
        source: /var/lib/longhorn
        options:
          - bind
          - rshared
          - rw
cluster:
  network:
    cni:
      name: none
  proxy:
    disabled: true
  # Optional Gateway API CRDs
  extraManifests:
  - https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.1.0/config/crd/standard/gateway.networking.k8s.io_gatewayclasses.yaml
  - https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.1.0/config/crd/experimental/gateway.networking.k8s.io_gateways.yaml
  - https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.1.0/config/crd/standard/gateway.networking.k8s.io_httproutes.yaml
  - https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.1.0/config/crd/standard/gateway.networking.k8s.io_referencegrants.yaml
  - https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.1.0/config/crd/standard/gateway.networking.k8s.io_grpcroutes.yaml
  - https://raw.githubusercontent.com/kubernetes-sigs/gateway-api/v1.1.0/config/crd/experimental/gateway.networking.k8s.io_tlsroutes.yaml
  - https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml
  - https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
  inlineManifests:
  - name: cilium-values
    contents: |
      ---
      apiVersion: v1
      kind: ConfigMap
      metadata:
        name: cilium-values
        namespace: kube-system
      data:
        values.yaml: |-
          ${indent(10, cilium_values)}
  - name: cilium-bootstrap
    contents: |
      ${indent(6, cilium_install)}
  - name: longhorn-install
    contents: |
      ${indent(6, longhorn_install)}
