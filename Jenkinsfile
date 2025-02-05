pipeline {
    agent any

    environment {
        // Declare environment variables if needed
    }

    tools {
        python 'Python 3.12' // Ensure Python is available
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm // Checkout the latest code from GitHub
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Create virtual environment and install dependencies
                    sh 'python3 -m venv venv'
                    sh '. venv/bin/activate && pip install -r requirements.txt'
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Run tests using pytest
                    sh '. venv/bin/activate && pytest --maxfail=1 --disable-warnings -q'
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main' // Deploy only on the 'main' branch
            }
            steps {
                script {
                    // Deploy to EC2 instance
                    sh '''#!/bin/bash
                    ssh -i /path/to/your-key.pem ubuntu@54.204.123.85 << 'EOF'
                        cd /home/ubuntu/flaskMicroblog
                        git pull origin main
                        source venv/bin/activate
                        pip install -r requirements.txt
                        sudo systemctl restart flask-microblog
                    EOF
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Build completed successfully.'
        }

        failure {
            echo 'Build failed. Check logs.'
        }

        always {
            echo 'Cleaning up resources...'
        }
    }
}
