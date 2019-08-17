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
| name | Component name | string | `"tiller"` | no |
| namespace | Namespace to where deploy tiller | string | n/a | yes |

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

