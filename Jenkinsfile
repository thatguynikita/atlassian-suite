pipeline {
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        // If you use MFA
        AWS_SESSION_TOKEN = credentials('AWS_SESSION_TOKEN')
    }
    agent {
        // Kubernetes plugin is required
        kubernetes {
            label 'terraform'
            containerTemplate {
                name 'terraform'
                image 'hashicorp/terraform:light'
                ttyEnabled true
                command 'cat'
            }
        }
    }
    stages {
        stage('Terraform Init') {
            steps {
                echo "Initializing Terraform working directory."
                sh 'terraform init -backend=true -input=false'
            }
        }
        stage('Terraform Validate') {
            steps {
                echo "Checking Terraform files for syntax errors."
                sh 'terraform validate -check-variables=false'
            }
        }
        stage('Terraform Plan') {
            steps {
                echo "Generating an execution plan."
                // Config File Provider plugin is required
                configFileProvider([configFile(fileId: 'terraform.tfvars', variable: 'TFVARFILE')]) {
                    sh 'terraform plan -var-file=${TFVARFILE} -input=false -out=plan.out'
                }
            }
            post {
                success {
                    // Slack plugin is required
                    slackSend channel: '@nikita', color: 'warning', message: "Plan Awaiting Approval for ${env.JOB_NAME} - #${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
                }
            }
        }
        stage('Terraform Apply') {
            options {
                timeout(time: 30, unit: 'MINUTES')
            }
            input {
                message "Should we deploy ${env.JOB_NAME} - ${env.BUILD_NUMBER} to Prod?"
                ok "Yes, go ahead"
            }
            steps {
                echo "Changing infrastructure according to Terraform configuration files."
                sh 'terraform apply -lock=false -input=false plan.out'
            }
        }
        stage('Terraform Show') {
            steps {
                echo "Terraform state in human-readable form."
                sh 'terraform show'
            }
        }
    }
    post {
        success {
            slackSend channel: '@nikita', color: 'good', message: "Changes Applied for ${env.JOB_NAME} - #${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
        }
        failure {
            slackSend channel: '@nikita', color: 'danger', message: "Apply Failed for ${env.JOB_NAME} - #${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
        }
    }
}
