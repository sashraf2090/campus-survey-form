pipeline {
    agent any

    environment {
        // Define environment variables
        REGISTRY_CREDENTIALS = 'docker-hub-credentials'  // Name of Jenkins credential for Docker registry
        DOCKER_IMAGE_NAME = 'your-docker-image-name'     // Name of your Docker image
        KUBE_NAMESPACE = 'default'                       // Kubernetes namespace to deploy to
        KUBE_DEPLOYMENT_NAME = 'your-deployment-name'    // Name of Kubernetes Deployment
        KUBE_CONTAINER_PORT = 8080                       // Port exposed by your Docker container
        KUBE_CONTAINER_NAME = 'your-container-name'      // Name of your container within Kubernetes
        KUBE_CONTEXT = 'your-kubernetes-context'         // Kubernetes context to use (optional)
        BUILD_TIMESTAMP = "${new Date().format('yyyyMMddHHmmss')}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'master', url: 'https://github.com/sashraf2090/campus-survey-form.git'
            }
        }

        stage('Build WAR File') {
            steps {
                script {
                    // Use jar command to create the WAR file
                    sh 'jar -cvf SurveyForm.war *'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', REGISTRY_CREDENTIALS) {
                        // Copy the WAR file to the Docker build context
                        sh 'cp SurveyForm.war .'
                        
                        // Build the Docker image with the build timestamp tag
                        def customImage = docker.build("sashraf2090/surveyformcontainer645:${BUILD_TIMESTAMP}", ".")
                        customImage.push()
                    }
                }
            }
        }
        
    }
}
