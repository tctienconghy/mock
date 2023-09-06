def runTerraform(environment) {
    def instanceIps = sh(
        script: "terraform -chdir=/Users/tctienconghygmail.com/.jenkins/workspace/job-jenkins/env/${environment}/frontend/ apply --lock=false -auto-approve && terraform -chdir=/Users/tctienconghygmail.com/.jenkins/workspace/job-jenkins/env/${environment}/frontend/ output list_ec2_ip",
        returnStdout: true
    ).trim()
    writeFile file: "${environment}_list_ec2_ip.txt", text: instanceIps
}

def generateDynamicInventory(environment) {
    sh 'pwd'
    sh 'ls -ltra'
    sh 'chmod +x select_workspace.sh'
    sh "dynamic_inventory.sh ${environment}"
}

def deployWithAnsible(environment) {
    sh 'pwd'
    sh 'chmod +x playbook.yml'
    sh 'chmod +x ${environment}_dynamic_inventory.json'
    sh "ansible-playbook -i ${environment}_dynamic_inventory playbook.yml"
}

def selectWorkspace(environment){
    sh 'chmod +x select_workspace.sh'
    sh "select_workspace.sh ${environment}"
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
                    sh 'terraform -chdir=/Users/tctienconghygmail.com/.jenkins/workspace/job-jenkins/env/${deployment_env}/frontend/ init --lock=false'
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
                    sh 'terraform -chdir=/Users/tctienconghygmail.com/.jenkins/workspace/job-jenkins/env/${deployment_env}/frontend/ validate'
                }
            }
        }
        // stage('plan') {
        //     when {
        //         expression { params.action == 'deploy'}
        //     }
        //     steps {
        //         echo "validate terraform with env: ${params.deployment_env}"
        //         withAWS(credentials: 'my_aws_access', region: 'us-east-1') {
        //             sh 'ls -ltra'
        //             sh 'terraform -chdir=/Users/tctienconghygmail.com/.jenkins/workspace/job-jenkins/env/${deployment_env}/frontend/ plan'
        //         }
        //     }
        // }
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
        // stage("generate dynamic inventory"){
        //     when {
        //         expression { params.action == 'deploy'}
        //     }
        //     steps {
        //         echo "genearte terraform with env: ${params.deployment_env}"
        //         withAWS(credentials: 'my_aws_access', region: 'us-east-1') {
        //             generateDynamicInventory("${params.deployment_env}")
        //         }
        //     }
        // }
        stage("deploy ansible"){
            when {
                expression { params.action == 'deploy'}
            }
            steps {
                echo "deploy ansible with env: ${params.deployment_env}"
                withAWS(credentials: 'my_aws_access', region: 'us-east-1') {
                    deployWithAnsible("${params.deployment_env}")
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
                    sh 'terraform -chdir=/Users/tctienconghygmail.com/.jenkins/workspace/job-jenkins/env/${deployment_env}/frontend/ destroy -auto-approve'
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
