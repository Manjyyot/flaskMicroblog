pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'flaskmicroblog:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from the 'main' branch of your public repository
                git branch: 'main', url: 'https://github.com/Manjyyot/flaskMicroblog.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Assuming a Python app with a requirements.txt
                    // Run a Python install of dependencies
                    sh 'pip install -r requirements.txt'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image using Dockerfile in the repository
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Run the container from the built image
                    sh 'docker run -d -p 5000:5000 ${DOCKER_IMAGE}'
                }
            }
        }
    }

    post {
        always {
            // Clean up docker container if needed
            sh 'docker ps -a -q | xargs docker rm -f'
        }
    }
}
