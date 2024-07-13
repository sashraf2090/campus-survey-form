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
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    docker.withRegistry('https://registry.hub.docker.com', REGISTRY_CREDENTIALS) {
                        def customImage = docker.build("sashraf2090/surveyformcontainer645:${env.BUILD_NUMBER}")
                        customImage.push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            environment {
                KUBE_CONFIG = credentials('your-kubeconfig-credentials-id') // Jenkins credential ID for kubeconfig
            }
            steps {
                script {
                    // Deploy to Kubernetes
                    def serverUrl = "https://your-kubernetes-api-server"
                    def caCert = readTrustedCaCert()
                    def kubeconfig = readKubeConfigFromSecret(KUBE_CONFIG)

                    // Set Kubernetes context if specified
                    if (KUBE_CONTEXT) {
                        sh "kubectl config use-context ${KUBE_CONTEXT}"
                    }

                    // Apply Kubernetes deployment
                    sh """
                        kubectl apply --kubeconfig=${kubeconfig} -f -
                        apiVersion: apps/v1
                        kind: Deployment
                        metadata:
                          name: ${KUBE_DEPLOYMENT_NAME}
                          namespace: ${KUBE_NAMESPACE}
                        spec:
                          replicas: 1
                          selector:
                            matchLabels:
                              app: ${KUBE_DEPLOYMENT_NAME}
                          template:
                            metadata:
                              labels:
                                app: ${KUBE_DEPLOYMENT_NAME}
                            spec:
                              containers:
                              - name: ${KUBE_CONTAINER_NAME}
                                image: ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}
                                ports:
                                - containerPort: ${KUBE_CONTAINER_PORT}
                      """

                    // Optionally, you can apply other Kubernetes resources like Services, Ingress, etc.
                }
            }
        }
    }
}