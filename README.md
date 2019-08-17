# Tiller Kubernetes Module

## Usage example

Here's the gist of using it via github.

```terraform
module tiller {
  source     = "https://github.com/terraform-module/terraform-kubernetes-tiller.git?ref=v0.2.0"
  namespace  = "helm"
  apps       = var.apps
  repository = data.helm_repository.stable.metadata.0.name
}
```

## Module Variables

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| automount\_service\_account\_token | Enable automatin mounting of the service account token | bool | `"true"` | no |
| component | Component name | string | `"helm"` | no |
| name | Generic name | string | `"tiller"` | no |
| namespace | Namespace to where deploy tiller | string | n/a | yes |
| service\_namespaces | The ServiceAccounts to grant permissions to. Example ['helm'] | list(string) | n/a | yes |
| tiller\_image | Tiller Docker image | string | `"gcr.io/kubernetes-helm/tiller:v2.14.2"` | no |
| tiller\_max\_history | Tiller history to contain | string | `"200"` | no |
| tiller\_replicas | Amound of replicas to deploy | string | `"1"` | no |
| tiller\_service\_type | Type of Tiller's Kubernetes service object. | string | `"ClusterIP"` | no |
| tiller\_version | Tiller version | string | `"v2.14.2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| service\_account | a service account |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Commands

<!-- START makefile-doc -->
```
$ make help 
hooks                          Commit hooks setup
validate                       Validate with pre-commit hooks
release                        Create release version 
```
<!-- END makefile-doc -->

## How to Contribute

Submit a pull request

## Validate creation of components

```sh
kubectl get serviceaccount <name> -o yaml
kubectl get clusterrolebinding <name> -o yaml
kubectl get deploy <name> -o yaml
```