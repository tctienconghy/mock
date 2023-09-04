def runTerraform(environment) {
    sh "terraform workspace select ${environment}"
    def instanceIps = sh(
        script: "terraform apply --lock=false -auto-approve && terraform output list_ec2_ip",
        returnStdout: true
    ).trim()
    writeFile file: "${environment}_list_ec2_ip.txt", text: instanceIps
}

def generateDynamicInventory(environment) {
    sh "./generate_inventory.sh ${environment}"
}

def deployWithAnsible(environment) {
    sh "ansible-playbook -i ${environment}_dynamic_inventory.json playbook.yml"
}

def selectWorkspace(environment){
    sh 'chmod +x select_workspace.sh'
    sh "pwd"
    sh "ls -ll"
    sh "./select_workspace.sh ${environment}"
}

pipeline {
    agent any
    parameters {
        choice choices: ['dev', 'prod'], name: 'deployment_env', description: "Choose env to build"
    }
    stages {
        // stage('select workspace') {
        //     steps {
        //         echo "select workspace: ${params.deployment_env}"
        //         selectWorkspace("${params.deployment_env}")
        //     }
        // }
        stage('init') {
            steps {
                echo "init terraform with env: ${params.deployment_env}"
                withAWS(credentials: 'my_aws_access', region: 'us-east-1') {
                sh 'pwd'
                sh 'terraform -chdir=/Users/tctienconghygmail.com/.jenkins/workspace/job-jenkins/env/${deployment_env}/frontend/ init --lock=false'
                }
            }
        }
        stage('validate') {
            steps {
                echo "validate terraform with env: ${params.deployment_env}"
                withAWS(credentials: 'my_aws_access', region: 'us-east-1') {
                sh 'pwd'
                sh 'terraform -chdir=/Users/tctienconghygmail.com/.jenkins/workspace/job-jenkins/env/${deployment_env}/frontend/ validate'
                }
            }
        }
        stage('plan') {
            steps {
                echo "validate terraform with env: ${params.deployment_env}"
                withAWS(credentials: 'my_aws_access', region: 'us-east-1') {
                sh 'ls -ltra'
                sh 'terraform -chdir=/Users/tctienconghygmail.com/.jenkins/workspace/job-jenkins/env/${deployment_env}/frontend/ plan'
                }
            }
        }
        stage("run terraform"){
            steps {
                echo "Run terraform with env: ${params.deployment_env}"
                withAWS(credentials: 'my_aws_access', region: 'us-east-1') {
                    runTerraform("${params.deployment_env}")
                }
            }
        }
        stage("generate dynamic inventory"){
            steps {
                echo "genearte terraform with env: ${params.deployment_env}"
                withAWS(credentials: 'my_aws_access', region: 'us-east-1') {
                    generateDynamicInventory("${params.deployment_env}")
                }
            }
        }
        stage("deploy ansible"){
            steps {
                echo "deploy ansible with env: ${params.deployment_env}"
                withAWS(credentials: 'my_aws_access', region: 'us-east-1') {
                    deployWithAnsible("${params.deployment_env}")
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
