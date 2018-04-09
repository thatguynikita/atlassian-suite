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
    stages {
        stage('Terraform verify') {
            steps {
                sh 'echo "This is just a test"'
                sh 'terraform verify'
            }
        }
    }
}
