pipeline {
    agent {
        node {
            label 't057-runner'
        }
    }

    stages {
        stage('Checkout') {
            steps {
                git credentialsId: 'ca-git-access', branch: 'develop', url: "https://git.cloudavise.com/visops/t057/full-stack-frond-backend.git"
            }
        }

        stage('prepare') {
            steps {
                sh "ansible-vault decrypt --vault-id /opt/naga-vault-id demokey.pem"
                sh "chmod 400 demokey.pem"
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
