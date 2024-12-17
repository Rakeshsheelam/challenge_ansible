pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AKIA5MSUBSOXB3WPSTAP')
        AWS_SECRET_ACCESS_KEY = credentials('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')
        TF_VAR_FRONTEND_IP = ''
        TF_VAR_BACKEND_IP = ''
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Init and Apply') {
            steps {
                script {
                    sh '''
                    cd terraform
                    terraform init
                    terraform apply -auto-approve
                    '''
                    env.TF_VAR_FRONTEND_IP = sh(script: "terraform output -raw frontend_ip", returnStdout: true).trim()
                    env.TF_VAR_BACKEND_IP = sh(script: "terraform output -raw backend_ip", returnStdout: true).trim()
                    echo "Frontend IP: ${env.TF_VAR_FRONTEND_IP}"
                    echo "Backend IP: ${env.TF_VAR_BACKEND_IP}"
                }
            }
        }
        stage('Prepare Ansible Inventory') {
            steps {
                script {
                    writeFile file: 'ansible/inventory/terraform_inventory.ini', text: """
[frontend]
${env.TF_VAR_FRONTEND_IP}
[backend]
${env.TF_VAR_BACKEND_IP}
"""
                }
            }
        }
        stage('Ansible - Configure Frontend') {
            steps {
                script {
                    sh '''
                    cd ansible
                    ansible-playbook frontend.yml
                    '''
                }
            }
        }
        stage('Ansible - Configure Backend') {
            steps {
                script {
                    sh '''
                    cd ansible
                    ansible-playbook playbooks/backend.yml
                    '''
                }
            }
        }
    }
    post {
        always {
            echo "Pipeline completed"
        }
        success {
            echo "Pipeline successfully finished!"
        }
        failure {
            echo "Pipeline failed. Check the logs for details."
        }
    }
}
