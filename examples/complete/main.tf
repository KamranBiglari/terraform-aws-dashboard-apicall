module "dashboard_apicall" {
    source  = "KamranBiglari/dashboard-apicall/aws"
    deployment_name = "cloudwatch-dashboard"
    timeout = 30
    memory_size = 1024
    vpc_id = ""
    vpc_subnet_ids = []
    vpc_security_group_ids = []
    policies = []

}