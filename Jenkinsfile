pipeline {
    agent {
		label 'linux-2108'
	}
    environment {
        MAVEN_OPTS = '-Xmx1024m'
    }
    stages {
        stage('Sourcecode checkout') {
            steps {
                echo 'Checkout repository using Jenkins Git credentials'
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/full-pipeline']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/MaheshGurram-devops/Online-bookstore.git',
                        credentialsId: 'Github-credentials-Uma'
                    ]]
                ])
            }
        }
        stage('Build') {
            steps {
                echo 'Build the project'
                sh '''
                    echo "Workspace: $pwd"
                    ls -l
                    java -version
                    mvn -version
                    mvn -B clean package
                '''
            }
        }
        stage ('Deployment') {
            steps {
                echo 'Build and run the Docker container'
                sh '''
                    set -e
                    IMAGE_NAME=onlinebookstore:latest
                    CONTAINER_NAME=onlinebookstore

                    echo "Building Docker image..."
                    sudo docker build -t "$IMAGE_NAME" .

                    echo "Replacing existing container if present..."
                    sudo docker rm -f "$CONTAINER_NAME" 2>/dev/null || true

                    echo "Starting application on port 8086..."
                    sudo docker run -d \\
                        --name "$CONTAINER_NAME" \\
                        --restart unless-stopped \\
                        -p 8086:8080 \\
                        "$IMAGE_NAME"

                    sudo docker ps --filter "name=$CONTAINER_NAME"
                '''
            }
        }
    }
    post {
        always {
            echo 'Archieving build artifacts'
            archiveArtifacts artifacts: '**/target/*.war, **/target/*executable.jar', fingerprint: true, allowEmptyArchive: true
        }
        success {
            echo 'Build completed successfully'
        }
        failure {
            echo 'Build failed'
        }
    }
}
