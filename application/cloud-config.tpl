#cloud-config
timezone: Europe/Berlin
write_files:
  - path: /etc/environment
    permissions: 0644
    content: |
        DB_ENDPOINT=${db_endpoint}
        DB_USERNAME=${db_username}
        DB_PASSWORD=${db_password}
        PROXIED_URL=${proxied_url}
        LISTENING_PORT=${listening_port}
        ENI_ID=${eni_id}
        EBS_ID=${ebs_id}
  - path: /tmp/${playbook_name}.zip
    permissions: '0744'
    content: !!binary |
            ${encoded}
packages:
  - python-psycopg2
  - zip
runcmd:
  - amazon-linux-extras install ansible2 && easy_install boto
  - echo -e "[localhost]\n127.0.0.1 ansible_connection=local" >> /etc/ansible/hosts
  - unzip /tmp/${playbook_name}.zip -d /tmp
  - while read -r line; do export $line; done < /etc/environment
  - ansible-playbook -vvvv /tmp/${playbook_name}.yml >> /var/log/ansible_${playbook_name}.log