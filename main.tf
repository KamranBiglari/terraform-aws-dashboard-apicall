# Defining a CloudWatch dashboard
resource "aws_cloudwatch_dashboard" "cloudwatch_dashboard" {
  # Use varaibale for name
  dashboard_name = var.APP_NAME

  # Encode the JSON for the dashboard using a for loop to iterate over all JSON files in the
  # cloudwatch_dashboard/dashboards directory

  dashboard_body = jsonencode({
    widgets = [for _, dashboard in fileset("${path.module}/cloudwatch_dashboard/dashboards", "*.json") : jsondecode(templatefile("${path.module}/cloudwatch_dashboard/dashboards/${dashboard}", {
      REFDB_CONFIG             = local.REFDB_CONFIG
      REFDB_SECRET_ID          = local.REFDB_SECRET_ID
      REDIS_CLUSTER_ENDPOINT   = local.REDIS_CLUSTER_ENDPOINT
      REDIS_CLUSTER_PORT       = local.REDIS_CLUSTER_PORT
      SERVICE_DOMAIN_WEBSOCKET = local.SERVICE_DOMAIN_WEBSOCKET
      REFERENCEAPI_ENDPOINT    = local.REFERENCEAPI_ENDPOINT
      ALARMS                   = local.FIAT_ALARMS
      REMOTE                      = local.REMOTE
      STEPFUNCTIONS_VARIABLES      = local.STEPFUNCTIONS_VARIABLES

      cloudwatch-dashboard-stepfunctions = {
        "servicecontrol"            = module.cloudwatch-dashboard-stepfunctions["servicecontrol"]
        "individual-servicecontrol" = module.cloudwatch-dashboard-stepfunctions["individual-servicecontrol"]
      }
      cloudwatch_dashboard_functions_lambda = {
        "redis-command"             = module.cloudwatch_dashboard_functions_lambda["redis-command"]
        "servicecontrol"            = module.cloudwatch_dashboard_functions_lambda["servicecontrol"]
        "awscall"                   = module.cloudwatch_dashboard_functions_lambda["awscall"]
        "websocket-monitoring"      = module.cloudwatch_dashboard_functions_lambda["websocket-monitoring"]
        "eventbridge-controller"    = module.cloudwatch_dashboard_functions_lambda["eventbridge-controller"]
        "individual-servicecontrol" = module.cloudwatch_dashboard_functions_lambda["individual-servicecontrol"]
      }
      })
    )]
  })

  # Adding dependencies 
  depends_on = [
    # module.cloudwatch_dashboard_functions_lambda,
    # module.cloudwatch-dashboard-stepfunctions,
  ]
}

resource "aws_security_group" "this" {
  count = length(var.vpc_security_group_ids) > 0 ? 0 : 1
  name        = "${var.deployment_name}-apicall-sg"
  description = "Allow all outbound traffic"
  
  # Use the VPC_ID local variable as the VPC ID for the security group (load data from remote state) 
  vpc_id      = local.VPC_ID

  # Allow all outbound traffic when use "-1"
  egress {
    description      = "Allow all outbound traffic or all ports"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  tags = {
    Name = "${var.deployment_name}-apicall-sg"
  }
}


# Using a module for lambda named "cloudwatch_dashboard_functions_lambda"
module "lambda" {
  # Source of moudle is form Terraform registry 
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 5.0"

  # Iterating over a list of CloudWatch dashboard folders and create a separate Lambda for each

  # Setting the name and description of the Lambda 
  function_name   = "${var.deployment_name}-apicall"
  description     = "cloudwatch dashboard lambda functions used in dashboard widget"

  # Specify the entry point for the Lambda which created earlier "CLOUDWATCH_DASHBOARD_FUNCTIONS" map 
  handler         = "index.js"
  runtime         = "nodejs18.x"

  # Timeout and retry attempt
  timeout                = var.timeout
  maximum_retry_attempts = 0
  memory_size = var.memory_size

  # Create a deployment package for the Lambda  and specify the source code location
  create_package = true
  source_path = [
    {
      path = "dist/"
      commands = [
        # ":zip",
        "cd ../",
        "npm i",
        "npm run build",
        "npm run clean",
        ":zip"
      ]
      patterns = [
        "!node_modules/.*",
        "!src/.*",
        "!node_modules",
        "!node_modules/",
        "!./node_modules",
        "!node_modules/*",
      ]
    }
  ]

  # Publish the Lambda after its build and attaching vpc and security group 
  publish                  = true
  vpc_subnet_ids           = var.vpc_subnet_ids
  vpc_security_group_ids   = var.vpc_security_group_ids
  ignore_source_code_hash  = false
  attach_network_policy    = true

  # Attacht (IAM) policy 
  attach_policies    = length(var.policies) > 0 ? true : false
  number_of_policies = length(var.policies)
  policies = var.policies

  # Setting Name tag 
  tags = {
    Name = "${var.deployment_name}-apicall"
  }

  # Specifing module dependencies 
  depends_on = [
    # data.archive_file.cloudwatch_dashboard_functions,
    aws_security_group.cloudwatch_dashboard_functions_sg
  ]
}
