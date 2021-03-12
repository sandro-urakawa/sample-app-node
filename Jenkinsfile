pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
		docker.withRegistry('https://registry.svc.intranet', '23a968ea-d3e4-4089-a349-c1c28d21c67d') {

       			def customImage = docker.build("registry.svc.intranet:app-node-jenkins:${env.BUILD_ID}")

        		/* Push the container to the custom Registry */
	        	customImage.push()
    		}
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
