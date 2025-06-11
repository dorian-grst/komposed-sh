# komposed-sh

## Overview

**komposed-sh** is a Kubernetes Operator built with the Operator SDK that enables users to convert Docker Compose files into Kubernetes manifests directly within a cluster. It is fully integrated into a GitOps pipeline using ArgoCD, making Compose-to-Kubernetes deployment seamless, automated, and observable.

This project is part of an advanced Kubernetes & GitOps lab, focusing on:

- Custom resource creation and reconciliation logic
- CI/CD automation for operator delivery
- GitOps deployment using ArgoCD
- Admission webhooks and validation
- Monitoring and observability of custom resources

## Repository Structure

```bash
.
├── infrastructure/       # Manifests for installing the operator and setting up the cluster
├── operator/             # Source code of the Operator (Go + Operator SDK)
├── sample/               # GitOps-watched directory (e.g. by ArgoCD) containing KomposeManifest resources
└── README.md             # Project documentation
```
