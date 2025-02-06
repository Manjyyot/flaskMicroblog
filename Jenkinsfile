pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                // Checkout code from your repository
                git 'https://github.com/Manjyyot/flaskMicroblog.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Set up a virtual environment
                    sh 'python3 -m venv venv'
                    
                    // Install dependencies from the requirements file
                    sh '. venv/bin/activate && pip install -r requirements.txt'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image with a tag (flaskmicroblog)
                    sh 'docker build -t flaskmicroblog:latest .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Run the Docker container in detached mode
                    sh 'docker run -d --name flaskmicroblog_container flaskmicroblog:latest'
                }
            }
        }
    }
}
