pipeline {
    agent any

    stages {
        stage('Code Clone') {
            steps {
                    echo "Code clonning"
                    git url: 'https://github.com/yashkapadi12/django-notes-app.git' , branch: 'yashcicd'
                  }
        }

        stage('Build') {
            steps {
                echo 'Building the Docker image'
                sh 'docker build -t notes-app:latest .'
                echo 'Docker image built successfully'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing Docker image to Docker Hub'
                withCredentials([usernamePassword(credentialsId: 'dockerHubCred', passwordVariable: 'dockerHubPass', usernameVariable: 'dockerHubUser')]) {
                    sh 'docker login -u $dockerHubUser -p $dockerHubPass'
                    sh 'docker tag notes-app:latest $dockerHubUser/notes-app:latest'
                    sh 'docker push $dockerHubUser/notes-app:latest'
                }
                echo 'Docker image pushed to Docker Hub successfully'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application using Docker Compose'
                sh 'docker compose down && docker compose up -d'
            }
        }
    }
}
