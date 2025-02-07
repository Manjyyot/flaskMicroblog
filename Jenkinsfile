pipeline {
    agent any

    environment {
        DB_DEV_LIB = 'libpq-dev'
        DOCKER_VERSION = 'latest'  // Use the latest Docker version
    }

    stages {
        stage('Preparation') {
            steps {
                script {
                    echo 'Preparing the environment...'
                    // Installing required packages (libpq-dev, Docker)
                    sh '''
                    echo Updating package list...
                    sudo apt-get update
                    sudo apt-get install -y libpq-dev
                    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
                    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
                    sudo apt-get update
                    echo Installing Docker...
                    sudo apt-get install -y docker-ce
                    '''
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    echo 'Building the project...'
                    // Adding debugging to verify Docker installation
                    sh '''
                    echo "Docker Info:"
                    docker info
                    docker images

                    echo "Performing build tasks"
                    # Ensure you have a valid Dockerfile in the root directory
                    if [ -f Dockerfile ]; then
                        echo "Dockerfile found, proceeding with build."
                    else
                        echo "Error: Dockerfile not found in the project root!"
                        exit 1
                    fi

                    echo "Starting Docker build..."
                    docker build -t flaskmicroblog .
                    '''
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    echo 'Running tests...'
                    // Running tests (example with dockerized tests)
                    sh '''
                    docker run --rm flaskmicroblog npm test
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    echo 'Deploying the application...'
                    // Deployment steps go here (e.g., push Docker image to registry)
                    sh '''
                    docker push flaskmicroblog
                    # Other deployment commands such as kubectl, aws-cli, etc.
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            // Add any cleanup steps if necessary (e.g., stopping containers)
            sh '''
            docker system prune -f
            '''
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Investigate logs!'
        }
    }
}
