output "db_endpoint" {
  value = "${module.postgres.endpoint}"
}
output "bitbucket_endpoint" {
  value = "${module.bitbucket_instance.static_ip}:${module.bitbucket_instance.listening_port}"
}
output "jira_endpoint" {
  value = "${module.jira_instance.static_ip}:${module.jira_instance.listening_port}"
}
output "confluence_endpoint" {
  value = "${module.confluence_instance.static_ip}:${module.confluence_instance.listening_port}"
}