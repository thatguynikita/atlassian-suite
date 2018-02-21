output "_DB endpoint" {
  value = "${module.postgres.endpoint}"
}
output "Bitbucket static IP" {
  value = "${module.bitbucket_instance.static_ip}"
}
output "Jira static IP" {
  value = "${module.jira_instance.static_ip}"
}
output "Confluence static IP" {
  value = "${module.confluence_instance.static_ip}"
}