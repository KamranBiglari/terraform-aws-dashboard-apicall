# terraform-aws-dashboard-apicall

## Examples
```
module "dashboard_apicall" {
    source  = "KamranBiglari/terraform-aws-dashboard-apicall"
    deployment_name = "cloudwatch-dashboard"
    timeout = 30
    memory_size = 1024
    vpc_id = ""
    vpc_subnet_ids = []
    vpc_security_group_ids = []
    policies = []

}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | terraform-aws-modules/lambda/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_dashboard.cloudwatch_dashboard](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_dashboard) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deployment_name"></a> [deployment\_name](#input\_deployment\_name) | value of deployment name | `string` | `"cloudwatch-dashboard"` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | value of memory for lambda | `number` | `1024` | no |
| <a name="input_policies"></a> [policies](#input\_policies) | value of policies | `list(string)` | `[]` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | value of timeout | `number` | `30` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | value of vpc id | `string` | `""` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | value of vpc security group ids | `list(string)` | `[]` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | value of vpc subnet ids | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->