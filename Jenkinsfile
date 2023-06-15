pipeline {
    agent {
        node {
            label 't059-runner'
        }
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'ca-git-access', branch: 'dev', url: "https://git.cloudavise.com/visops/t059/sample-fullstack-app.git"
            }
        }

        stage('prepare') {
            steps {
                sh "ansible-vault decrypt --vault-id /opt/vault_id ec2-1.pem"
                sh "chmod 400 ec2-1.pem"
                sh "ansible-playbook -i inventory fullstack-deploy.yml"
            }
        }
    }

    post {
        always {
            script {
                userInput = input(
                    id: 'userConfirmation',
                    message: 'Confirm to proceed with Docker cleanup',
                    parameters: [
                        [$class: 'BooleanParameterDefinition', defaultValue: false, description: '', name: 'PROCEED']
                    ]
                )
                if (userInput.PROCEED) {
                    sh 'docker-compose down'
                }
            }
        }
    }
}
