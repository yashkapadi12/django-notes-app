pipeline {
    agent any

    environment {
        IMAGE_NAME = 'notes-app'
    }

    stages {
        stage('Code Clone') {
            steps {
                echo "Code cloning"
                git url: 'https://github.com/yashkapadi12/django-notes-app.git', branch: 'yashcicd'
                script {
                    GIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    env.GIT_HASH = GIT_HASH
                }
            }
        }

        stage('Build') {
            steps {
                echo 'Building the Docker image'
                sh 'docker build -t $IMAGE_NAME:$GIT_HASH .'
                sh 'docker tag $IMAGE_NAME:$GIT_HASH $IMAGE_NAME:latest'
                echo 'Docker image built and tagged with git hash'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests'
                // Add test command here if any
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing Docker image to Docker Hub'
                withCredentials([usernamePassword(credentialsId: 'DockerHubCred', passwordVariable: 'dockerHubPass', usernameVariable: 'dockerHubUser')]) {
                    sh 'docker login -u $dockerHubUser -p $dockerHubPass'
                    sh 'docker tag $IMAGE_NAME:$GIT_HASH $dockerHubUser/$IMAGE_NAME:$GIT_HASH'
                    sh 'docker tag $IMAGE_NAME:$GIT_HASH $dockerHubUser/$IMAGE_NAME:latest'
                    sh 'docker push $dockerHubUser/$IMAGE_NAME:$GIT_HASH'
                    sh 'docker push $dockerHubUser/$IMAGE_NAME:latest'
                }
                echo 'Docker image pushed to Docker Hub with git hash and latest tag'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application using Docker image from Docker Hub'
                withCredentials([usernamePassword(credentialsId: 'DockerHubCred', passwordVariable: 'dockerHubPass', usernameVariable: 'dockerHubUser')]) {
                    sh 'docker login -u $dockerHubUser -p $dockerHubPass'
                    sh 'docker pull $dockerHubUser/$IMAGE_NAME:$GIT_HASH'
                    sh 'docker stop $IMAGE_NAME || true'
                    sh 'docker rm $IMAGE_NAME || true'
                    sh "docker compose down && docker compose up -d"
                }
            }
        }
    }
}
