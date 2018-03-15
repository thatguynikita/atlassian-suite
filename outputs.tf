output "_DB endpoint" {
  value = "${module.postgres.endpoint}"
}
output "Bitbucket static endpoint" {
  value = "${module.bitbucket_instance.static_ip}:${module.bitbucket_instance.listening_port}"
}
output "Jira static endpoint" {
  value = "${module.jira_instance.static_ip}:${module.jira_instance.listening_port}"
}
output "Confluence static endpoint" {
  value = "${module.confluence_instance.static_ip}:${module.confluence_instance.listening_port}"
}