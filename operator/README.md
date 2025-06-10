# komposed-sh

## Description

**komposed-sh** is a Kubernetes Operator built with the Operator SDK. Its purpose is to automatically convert `docker-compose.yaml` files into Kubernetes manifests directly within a cluster.

By defining a custom resource (`KomposeManifest`), users can submit a Docker Compose file as a YAML string. The operator will then:

1. Convert the file into Kubernetes manifests using [Kompose](https://github.com/kubernetes/kompose),
2. Automatically apply those manifests in the target namespace using `kubectl`.

This project is designed to fit into a GitOps workflow, where the conversion and deployment of Compose-based applications are automated and version-controlled.

### Use Cases

- Quickly migrate existing applications from Docker Compose to Kubernetes.
- Integrate Compose-to-Kubernetes conversion into GitOps pipelines (e.g., with ArgoCD).
- Eliminate manual errors when translating Docker configurations to Kubernetes resources.

## Getting Started

### Prerequisites

- go version v1.22.0+
- docker version 17.03+.
- kubectl version v1.11.3+.
- kompose version v1.0.0+.
- Access to a Kubernetes v1.11.3+ cluster.

### To Deploy on the cluster

**Build and push your image to the location specified by `IMG`:**

```sh
make docker-build docker-push IMG=<some-registry>/komposed-sh:tag
```

**NOTE:** This image ought to be published in the personal registry you specified.
And it is required to have access to pull the image from the working environment.
Make sure you have the proper permission to the registry if the above commands don’t work.

**Install the CRDs into the cluster:**

```sh
make install
```

**Deploy the Manager to the cluster with the image specified by `IMG`:**

```sh
make deploy IMG=<some-registry>/komposed-sh:tag
```

> **NOTE**: If you encounter RBAC errors, you may need to grant yourself cluster-admin
> privileges or be logged in as admin.

**Create instances of your solution**
You can apply the samples (examples) from the config/sample:

```sh
kubectl apply -k config/samples/
```

> **NOTE**: Ensure that the samples has default values to test it out.

### To Uninstall

**Delete the instances (CRs) from the cluster:**

```sh
kubectl delete -k config/samples/
```

**Delete the APIs(CRDs) from the cluster:**

```sh
make uninstall
```

**UnDeploy the controller from the cluster:**

```sh
make undeploy
```

## Project Distribution

Following are the steps to build the installer and distribute this project to users.

1. Build the installer for the image built and published in the registry:

```sh
make build-installer IMG=<some-registry>/komposed-sh:tag
```

NOTE: The makefile target mentioned above generates an 'install.yaml'
file in the dist directory. This file contains all the resources built
with Kustomize, which are necessary to install this project without
its dependencies.

2. Using the installer

Users can just run kubectl apply -f <URL for YAML BUNDLE> to install the project, i.e.:

```sh
kubectl apply -f https://raw.githubusercontent.com/<org>/komposed-sh/<tag or branch>/dist/install.yaml
```
