# [terraform-azurerm-applicationinsights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights)

Manages an Application Insights component.

## Getting Started

- Format and validate terraform code before commit.

```shell
terraform init -upgrade \
    && terraform init -reconfigure -upgrade \
    && terraform fmt -recursive . \
    && terraform fmt -check \
    && terraform validate .
```

- Always fetch latest changes from upstream and rebase from it. Terraform documentation will always be updated with GitHub Actions. See also [.github/workflows/terraform.yml](.github/workflows/terraform.yml) GitHub Actions workflow.

```shell
git fetch --all --prune --prune-tags \
  && git pull --rebase --all --prune --tags
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
