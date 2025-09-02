# output "environment" {
#     value = { for k, m in module.dev_acr : k => m }
# }

output "env" {
    value = { for k,i in local.environments : k => i }
}