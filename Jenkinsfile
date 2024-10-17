pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-cred')
        
        // Add Docker's path
        PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:${env.PATH}"
    }

    triggers {
        githubPush()  // Trigger on push to GitHub
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo "Cloning the repository..."
                    git branch: 'main',
                        url: 'https://github.com/Anugrah1712/Devops.git'
                }
            }
        }
  

  
        stage('Build Docker Image') { 
            steps {
                script {
                    echo "Building Docker image..."
                    // Build the Docker image with your Docker Hub tag
                    sh 'docker build -t anugrah1712/flexidevops:latest .'
                }
            }
        }

        stage('Login to DockerHub') {
            steps {
                script {
                    echo "Logging in to DockerHub..."
                    withCredentials([usernamePassword(credentialsId: 'docker-cred', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                        sh '''
                        echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USER --password-stdin
                        '''
                    }
                }
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    echo "Pushing Docker image to DockerHub..."
                    // Push the Docker image to DockerHub
                    sh 'docker push anugrah1712/flexidevops:latest'
                }
            }
        }

        // SonarQube Analysis Stage
        stage('SonarQube Analysis') {
            steps {
                script {
                    // Ensure SonarQube Scanner is available in Jenkins
                    def scannerHome = tool 'SonarQube Scanner'
                    withSonarQubeEnv('SonarQube') {
                        sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=flexi -Dsonar.projectName=flexi"
                    }
                }
            }
        }
        

        stage('Logout from DockerHub') {
            steps {
                script {
                    echo "Logging out from DockerHub..."
                    sh 'docker logout'
                }
            }
        }
    } 

    post {
        always {
            echo "Cleaning up the workspace..."
            cleanWs()  // Clean workspace after the build
        }
        failure {
            echo 'Build failed!'
        }
        success {
            echo 'Build succeeded!'
        }
    }
}