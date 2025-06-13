pipeline {
    agent any

    parameters {
        string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Branch to deploy')
        choice(name: 'ENVIRONMENT', choices: ['development', 'production'], description: 'Target environment')
    }

    environment {
        IMAGE_NAME = 'notes-app'
    }

    stages {
        stage('Clone Code') {
            steps {
                echo "Cloning branch: ${params.BRANCH_NAME}"
                git url: 'https://github.com/yashkapadi12/django-notes-app.git', branch: "${params.BRANCH_NAME}"
            }
        }

        stage('Build Image') {
            steps {
                script {
                    def GIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    env.TAG = GIT_HASH
                    echo "Tagging image as: ${IMAGE_NAME}:${TAG}"
                    sh "docker build -t ${IMAGE_NAME}:${TAG} ."
                }
            }
        }

        stage('Push Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DockerHubCred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'docker login -u $USER -p $PASS'
                    sh "docker tag ${IMAGE_NAME}:${TAG} $USER/${IMAGE_NAME}:${TAG}"
                    sh "docker push $USER/${IMAGE_NAME}:${TAG}"
                }
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DockerHubCred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh 'docker login -u $USER -p $PASS'
                    sh "docker pull $USER/${IMAGE_NAME}:${TAG}"
                    sh 'docker stop notes-app || true'
                    sh 'docker rm notes-app || true'
                    sh "docker run -d --name notes-app $USER/${IMAGE_NAME}:${TAG}"
                }
            }
        }
    }
}
