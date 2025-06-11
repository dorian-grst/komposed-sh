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
