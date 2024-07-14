pipeline {
    agent any

    environment {
        // Define environment variables
        REGISTRY_CREDENTIALS = 'docker-hub-credentials'  // Name of Jenkins credential for Docker registry
        DOCKER_IMAGE_NAME = 'sashraf2090/surveyformcontainer645'     // Name of your Docker image
        KUBE_NAMESPACE = 'default'                       // Kubernetes namespace to deploy to
        KUBE_DEPLOYMENT_NAME = 'survey-form-deployment'    // Name of Kubernetes Deployment
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
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh """
                            echo \$DOCKER_PASSWORD | docker login -u \$DOCKER_USERNAME --password-stdin
                            docker build -t sashraf2090/surveyformcontainer645:${BUILD_TIMESTAMP} .
                            docker push sashraf2090/surveyformcontainer645:${BUILD_TIMESTAMP}
                        """
                    }
                }
            }
        }

        stage('Deploy to Rancher Kubernetes Cluster') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'kubeconfig', variable: 'KUBECONFIG')]) {
                        sh """
                            kubectl --kubeconfig=\$KUBECONFIG apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${KUBE_DEPLOYMENT_NAME}
  namespace: ${KUBE_NAMESPACE}
spec:
  replicas: 3
  selector:
    matchLabels:
      app: ${KUBE_DEPLOYMENT_NAME}
  template:
    metadata:
      labels:
        app: ${KUBE_DEPLOYMENT_NAME}
    spec:
      containers:
      - name: ${KUBE_DEPLOYMENT_NAME}
        image: ${DOCKER_IMAGE_NAME}:${BUILD_TIMESTAMP}
        ports:
        - containerPort: 8080
EOF
                        """
                    }
                }
            }
        }
    }
}
