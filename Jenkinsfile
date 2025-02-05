pipeline {
    agent any

    environment {
        // Set Python environment variable (if needed for your setup)
        PYTHON = 'python3'
        PIP = 'pip3'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from GitHub repository
                git 'https://github.com/Manjyyot/flaskMicroblog.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Install Python dependencies
                    sh '${PIP} install -r requirements.txt'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run tests using pytest
                    sh '${PYTHON} -m pytest tests.py'
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                script {
                    // Placeholder for deploy step (e.g., SSH or cloud deployment)
                    echo 'Deploying to staging...'
                    // You can uncomment the following line if you set up a real deployment environment
                    // sh 'bash deploy.sh'  // Add your deploy script here
                }
            }
        }
    }

    post {
        always {
            // Always send notification (e.g., email) or cleanup resources after the pipeline
            echo 'Cleaning up resources...'
        }

        success {
            // Success notification (e.g., email or Slack) if build passes
            echo 'Build passed! Deploying application...'
        }

        failure {
            // Failure notification (e.g., email or Slack) if build fails
            echo 'Build failed! Please check logs.'
        }
    }
}
