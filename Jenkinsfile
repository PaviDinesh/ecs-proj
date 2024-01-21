pipeline {
    agent any
    stages {
        stage('SCM checkout') {
            steps {
                script {
                    git credentialsId: 'git-token', url: 'https://github.com/PaviDinesh/devops.git'
                }
            }
        }
        stage('Build') {
            steps {
                script {
                    sh 'npm install'
                }
            }
        }
        stage('Docker Build Images') {
            steps {
                script {
                    sh 'docker build -t pavimd24/helm:v1 .'
                    sh 'docker images'
                }
            }
        }
        stage('Docker Push') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'dockerPass', variable: 'dockerPassword')]) {
                        sh "docker login -u pavimd24 -p ${dockerPassword}"
                        sh 'docker push pavimd24/helm:v1'
                    }
                }
            }
        }
        stage('Deploy on k8s') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
     echo 'Inside withAWS block'
                  withKubeCredentials(
                        kubectlCredentials: [[credentialsId: 'kubernetes']]
                    ) {
                        
                       
                        sh 'kubectl get nodes'
                        sh 'kubectl create secret generic helm --from-file=.dockerconfigjson=/opt/docker/config.json  --type kubernetes.io/dockerconfigjson --dry-run=client -oyaml > secret.yaml'
                        sh 'kubectl apply -f secret.yaml'
                        sh 'helm package ./Helm'
                        sh 'helm install myrocket ./myrocketapp-0.2.0.tgz'
                        sh 'helm ls'
                        sh 'kubectl get pods -o wide'
                        sh 'kubectl get svc'

                    }
                    }
  
                }
            }
        }
    }
}
