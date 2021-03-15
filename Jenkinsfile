pipeline {
    environment {	
        registry = '251815888428.dkr.ecr.us-east-1.amazonaws.com'
        registryCredential = 'aws-credentials'
        dockerImage = ''
    }
    agent {
        kubernetes {
            label 'spring-petclinic-demo'
            defaultContainer 'jnlp'
            yaml """
apiVersion: v1
kind: Pod
metadata:
labels:
  component: ci
spec:
  # Use service account that can deploy to all namespaces
  serviceAccountName: jenkins-master
  containers:
  - name: docker
    image: docker:latest
    command:
    - cat
    tty: true
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-sock
  volumes:
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
"""
        }
    }
    stages {
        stage('Cloning Git') {
            steps {
                git branch: 'master',
                    credentialsId: 'sandro.urakawa-github',
                    url: 'https://github.com/sandro-urakawa/sample-app-node.git'
            }
        }
        stage('Build Image') { 
            steps { 
                sh "ls"
                container('docker') {
		    script {
		        dockerImage = docker.build registry + "/mendix-jenkins:$BUILD_NUMBER"
		    }
                }
            }
        }
        stage('Verify Image') { 
            steps { 
                container('docker') {
                    sh """
                        docker images
                    """
                }
            }
        }
        stage('Push Image') { 
            steps {
	        container('docker') {
		    script{
		        docker.withRegistry("https://" + registry, "ecr:us-east-1:" + registryCredential) {
                            dockerImage.push("latest")
                            dockerImage.push()
                        }
                    }
                }
            }
        }
        stage('Deploy App') {
            steps {
                script {
                   kubernetesDeploy(configs: "sample-node-app.yaml", kubeconfigId: "mykubeconfig")
                }
            }
        }
    }
}
