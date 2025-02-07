pipeline {
    agent any

    environment {
        DB_DEV_LIB = 'libpq-dev'
        DOCKER_VERSION = 'latest'  // Use the latest Docker version
        DOCKERHUB_REPO = 'Manjyyot/flaskmicroblog'  // Docker Hub username/repo
        EC2_IP = '3.82.17.168'  // EC2 public IP
        SSH_KEY_PATH = '/path/to/ManjyotKeyPair.pem'  // Path to your EC2 SSH private key
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

        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building the Docker image...'
                    // Ensure you have a valid Dockerfile in the root directory
                    if (fileExists('Dockerfile')) {
                        echo "Dockerfile found, proceeding with build."
                    } else {
                        echo "Error: Dockerfile not found!"
                        currentBuild.result = 'FAILURE'
                        return
                    }
                    
                    echo 'Building Docker image...'
                    sh '''
                    docker build -t flaskmicroblog .
                    '''
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    echo 'Pushing Docker image to Docker Hub...'
                    // Log in to Docker Hub (Jenkins credentials required)
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                        sh '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        docker tag flaskmicroblog $DOCKER_USERNAME/flaskmicroblog
                        docker push $DOCKER_USERNAME/flaskmicroblog
                        '''
                    }
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    echo 'Deploying Docker container to EC2...'

                    // Make sure Docker is installed on your EC2
                    // You will need to have your EC2 instance accessible from Jenkins via SSH

                    sh '''
                    # SSH into EC2 and run the Docker container
                    ssh -i $SSH_KEY_PATH -o StrictHostKeyChecking=no ubuntu@$EC2_IP "
                    docker pull $DOCKER_USERNAME/flaskmicroblog &&
                    docker run -d -p 5000:5000 $DOCKER_USERNAME/flaskmicroblog
                    "
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
