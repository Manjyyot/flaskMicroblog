pipeline {
    agent any

    environment {
        // You can define any global environment variables here
        DB_DEV_LIB = 'libpq-dev'
        DOCKER_VERSION = '20.10'
    }

    stages {
        stage('Preparation') {
            steps {
                script {
                    echo 'Preparing the environment...'
                    // Installing required packages (libpq-dev, Docker)
                    sh '''
                    sudo apt-get update
                    sudo apt-get install -y libpq-dev
                    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
                    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
                    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
                    sudo apt-get update
                    sudo apt-get install -y docker-ce=${DOCKER_VERSION}
                    '''
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    echo 'Building the project...'
                    // Insert your build steps here (e.g., building a Docker image, or compiling code)
                    sh '''
                    echo "Performing build tasks"
                    # Example build command, adjust as needed
                    docker build -t your-app-name .
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
                    docker run --rm your-app-name npm test
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
                    docker push your-app-name
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
