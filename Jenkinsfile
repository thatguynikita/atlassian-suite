pipeline {
    agent {
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
    environment {
        AWS = 'test'
    }
    stages {
        stage('Terraform Init') {
            steps {
                sh 'echo "This is just a test"'
                sh 'terraform init'
            }
        }
        stage('Terraform Validate') {
            steps {
                sh 'echo "This is just a test"'
                sh 'terraform validate'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'echo "This is just a test"'
                sh 'terraform plan'
            }
        }
        stage('Terraform Apply to Prod') {
            input {
                message "Should we deploy on Prod?"
                ok "Yes, go ahead"
            }
            steps {
                sh 'echo "This is just a test"'
                sh 'terraform apply'
            }
        }
    }
}
