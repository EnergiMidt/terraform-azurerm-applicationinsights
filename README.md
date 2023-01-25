# [terraform-azurerm-applicationinsights][1]

Manages an Application Insights component.

## Getting Started

- Format and validate Terraform code before commit.

```shell
terraform init -upgrade \
    && terraform init -reconfigure -upgrade \
    && terraform fmt -recursive . \
    && terraform fmt -check \
    && terraform validate .
```

- Always fetch latest changes from upstream and rebase from it. Terraform documentation will always be updated with GitHub Actions. See also [.github/workflows/terraform.yml](.github/workflows/terraform.yml) GitHub Actions workflow.

```shell
git fetch --all --tags --prune --prune-tags \
  && git pull --rebase --all --prune --tags
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.33.0, < 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.40.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.application_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_application_insights_web_test.web_test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights_web_test) | resource |
| [azurerm_monitor_action_group.action_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | (Required) Name of this resource within the system it belongs to (see naming convention guidelines).<br>  Will be part of the final name of the deployed resource. | `string` | n/a | yes |
| <a name="input_application_type"></a> [application\_type](#input\_application\_type) | (Optional) Specifies the type of Application Insights to create. Valid values are `ios` for iOS, `java` for Java web, `MobileCenter` for App Center, `Node.JS` for Node.js, `other` for General, `phone` for Windows Phone, `store` for Windows Store and `web` for ASP.NET. Please note these values are case sensitive; unmatched values are treated as ASP.NET by Azure. Changing this do not force a new resource to be created. | `string` | `"other"` | no |
| <a name="input_daily_data_cap_in_gb"></a> [daily\_data\_cap\_in\_gb](#input\_daily\_data\_cap\_in\_gb) | (Optional) Specifies the Application Insights component daily data volume cap in GB. | `number` | `0.15` | no |
| <a name="input_daily_data_cap_notifications_disabled"></a> [daily\_data\_cap\_notifications\_disabled](#input\_daily\_data\_cap\_notifications\_disabled) | (Optional) Specifies if a notification email will be send when the daily data volume cap is met. | `bool` | `false` | no |
| <a name="input_disable_ip_masking"></a> [disable\_ip\_masking](#input\_disable\_ip\_masking) | (Optional) By default the real client IP is masked as `0.0.0.0` in the logs. Use this argument to disable masking and log the real client IP. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) The name of the environment. | `string` | n/a | yes |
| <a name="input_force_customer_storage_for_profiler"></a> [force\_customer\_storage\_for\_profiler](#input\_force\_customer\_storage\_for\_profiler) | (Optional) Should the Application Insights component force users to create their own storage account for profiling? Defaults to `false`. | `bool` | `false` | no |
| <a name="input_internet_ingestion_enabled"></a> [internet\_ingestion\_enabled](#input\_internet\_ingestion\_enabled) | (Optional) Should the Application Insights component support ingestion over the Public Internet? Defaults to `true`. | `bool` | `true` | no |
| <a name="input_internet_query_enabled"></a> [internet\_query\_enabled](#input\_internet\_query\_enabled) | (Optional) Should the Application Insights component support querying over the Public Internet? Defaults to `true`. | `bool` | `true` | no |
| <a name="input_local_authentication_disabled"></a> [local\_authentication\_disabled](#input\_local\_authentication\_disabled) | (Optional) Disable Non-Azure AD based Auth. Defaults to `false`. | `bool` | `false` | no |
| <a name="input_monitor_action_group"></a> [monitor\_action\_group](#input\_monitor\_action\_group) | (Optional) The map of action group(s).<br>Example:<pre>{<br>  smart_detect = {<br>    name       = "Application Insights Smart Detection"<br>    short_name = "SmartDetect"<br><br>    arm_role_receiver = data.azurerm_role_definition.roles<br><br>    email_receiver = [<br>      {<br>        name                    = "Ola Nordmann"<br>        email_address           = "ola@nordmann.no"<br>        use_common_alert_schema = true<br>      },<br>      {<br>        name                    = "Kari Nordmann"<br>        email_address           = "kari@nordmann.no"<br>        use_common_alert_schema = false<br>      }<br>    ]<br>  }<br>}</pre> | <pre>map(<br>    object({<br>      name              = string<br>      short_name        = string<br>      arm_role_receiver = optional(set(object({})))<br>      email_receiver = optional(<br>        list(<br>          object(<br>            {<br>              name                    = string<br>              email_address           = string<br>              use_common_alert_schema = bool<br>            }<br>          )<br>        )<br>      )<br>    })<br>  )</pre> | `{}` | no |
| <a name="input_override_location"></a> [override\_location](#input\_override\_location) | (Optional) Override the location of the resource. Under normal circumstances, it should not be used. | `string` | `null` | no |
| <a name="input_override_name"></a> [override\_name](#input\_override\_name) | (Optional) Override the name of the resource. Under normal circumstances, it should not be used. | `string` | `null` | no |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | (Required) The resource group in which to create the resource. | `any` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | (Optional) Specifies the retention period in days. Possible values are `30`, `60`, `90`, `120`, `180`, `270`, `365`, `550` or `730`. Defaults to `30` for cost optimization instead of upstream `90`. | `number` | `"30"` | no |
| <a name="input_sampling_percentage"></a> [sampling\_percentage](#input\_sampling\_percentage) | (Optional) Specifies the percentage of the data produced by the monitored application that is sampled for Application Insights telemetry. | `number` | `"100"` | no |
| <a name="input_system_short_name"></a> [system\_short\_name](#input\_system\_short\_name) | (Required) Short abbreviation (to-three letters) of the system name that this resource belongs to (see naming convention guidelines).<br>  Will be part of the final name of the deployed resource. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_web_test_endpoints"></a> [web\_test\_endpoints](#input\_web\_test\_endpoints) | (Optional) The map of web test endpoint(s).<br>Example:<pre>{<br>  "webTestName" = {<br>    url : "Specify the URL to test."<br>    frequency : "Interval in seconds between test runs for this WebTest. Valid options are 300, 600 and 900."<br>    timeout : "Seconds until this WebTest will timeout and fail."<br>    enabled : "Is the test actively being monitored?"<br>    geo_locations : "A list of where to physically run the tests from to give global coverage for accessibility of your application."<br>  }<br>}</pre> | <pre>map(<br>    object({<br>      url           = string<br>      frequency     = optional(number)<br>      timeout       = optional(number)<br>      enabled       = optional(bool)<br>      retry_enabled = optional(bool)<br>      geo_locations = optional(list(string))<br>    })<br>  )</pre> | `{}` | no |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | (Optional) Specifies the id of a log analytics workspace resource. Changing this forces a new resource to be created. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azurerm_application_insights"></a> [azurerm\_application\_insights](#output\_azurerm\_application\_insights) | The Azure Application Insights resource. |
| <a name="output_azurerm_application_insights_web_test"></a> [azurerm\_application\_insights\_web\_test](#output\_azurerm\_application\_insights\_web\_test) | The Azure Application Insights Web Test resource. |
<!-- END_TF_DOCS -->

[1]: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights
