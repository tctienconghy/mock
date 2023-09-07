def runTerraform(environment) {
    sh "terraform -chdir=/Users/tctienconghygmail.com/.jenkins/workspace/jenkins_mock/env/${environment}/frontend/ apply --lock=false -auto-approve"
}

def generateDynamicInventory(environment) {
    sh 'pwd'
    sh 'ls -ltra'
    sh 'chmod +x select_workspace.sh'
    sh "dynamic_inventory.sh ${environment}"
}

pipeline {
    agent any
    parameters {
        choice (choices: ['dev', 'prod'], name: 'deployment_env', description: "Choose env to build")
        choice (choices: ['deploy', 'destroy'], name: 'action', description: "Choose an action")
    }
    stages {
        stage('init') {
            when {
                expression { params.action == 'deploy'}
            }
            steps {
                echo "init terraform with env: ${params.deployment_env}"
                withAWS(credentials: 'my_aws_access', region: 'us-east-1') {
                    sh 'terraform -chdir=/Users/tctienconghygmail.com/.jenkins/workspace/jenkins_mock/env/${deployment_env}/frontend/ init --lock=false'
                }
            }
        }
        stage('validate') {
            when {
                expression { params.action == 'deploy'}
            }
            steps {
                echo "validate terraform with env: ${params.deployment_env}"
                withAWS(credentials: 'my_aws_access', region: 'us-east-1') {
                    sh 'terraform -chdir=/Users/tctienconghygmail.com/.jenkins/workspace/jenkins_mock/env/${deployment_env}/frontend/ validate'
                }
            }
        }
        stage('plan') {
            when {
                expression { params.action == 'deploy'}
            }
            steps {
                echo "validate terraform with env: ${params.deployment_env}"
                withAWS(credentials: 'my_aws_access', region: 'us-east-1') {
                    sh 'terraform -chdir=/Users/tctienconghygmail.com/.jenkins/workspace/jenkins_mock/env/${deployment_env}/frontend/ plan'
                }
            }
        }
        stage("run terraform"){
            when {
                expression { params.action == 'deploy'}
            }
            steps {
                echo "Run terraform with env: ${params.deployment_env}"
                withAWS(credentials: 'my_aws_access', region: 'us-east-1') {
                    runTerraform("${params.deployment_env}")
                }
            }
        }
        stage("deploy ansible"){
            when {
                expression { params.action == 'deploy'}
            }
            steps {
                sh 'pwd'
                sh 'ls -ltra'
                sh 'chmod +x $(which ansible-playbook)'
                sh 'cat /Users/tctienconghygmail.com/.jenkins/workspace/jenkins_mock/playbook.yml'
                sh 'chmod +x /Users/tctienconghygmail.com/.jenkins/workspace/jenkins_mock/${deployment_env}_dynamic_inventory'
                sh 'cat /Users/tctienconghygmail.com/.jenkins/workspace/jenkins_mock/${deployment_env}_dynamic_inventory'
                script {
                    def workspaceDir = pwd()
                    sh "ls $workspaceDir"  // List files in the workspace
                    ansiblePlaybook (
                        credentialsId: 'my_key',
                        playbook: '/Users/tctienconghygmail.com/.jenkins/workspace/jenkins_mock/playbook.yml',
                        inventory: '/Users/tctienconghygmail.com/.jenkins/workspace/jenkins_mock/${deployment_env}_dynamic_inventory',
                        become: 'yes'
                    )
                }
            }
        }
        stage("destroy"){
            when {
                expression { params.action == 'destroy'}
            }
            steps {
                echo "start to destroy with env: ${params.deployment_env}"
                withAWS(credentials: 'my_aws_access', region: 'us-east-1') {
                    sh 'terraform -chdir=/Users/tctienconghygmail.com/.jenkins/workspace/jenkins_mock/env/${deployment_env}/frontend/ destroy -auto-approve'
                }
            }
        }
    }
    post {
        success {
            echo "SUCCESSFULL"
        }
        failure {
            echo "FAILED"
        }
    }
}
