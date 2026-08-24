pipeline {
    agent {
		label 'linux-2108'
	}
    environment {
        MAVEN_OPTS = '-Xmx512m -XX:MaxMetaspaceSize=128m'
        DOCKER_IMAGE = 'onlinebookstore:latest'
        DOCKER_CONTAINER = 'onlinebookstore'
        APPLICATION_PORT = '8086'
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

                    echo "Building Docker image..."
                    sudo docker build -t "$DOCKER_IMAGE" .

                    echo "Stopping and removing existing application containers..."
                    EXISTING_CONTAINERS=$(sudo docker container ls -aq --filter "name=^/${DOCKER_CONTAINER}$")
                    if [ -n "$EXISTING_CONTAINERS" ]; then
                        sudo docker container rm --force $EXISTING_CONTAINERS
                    fi

                    echo "Starting application on port $APPLICATION_PORT..."
                    sudo docker run -d \\
                        --name "$DOCKER_CONTAINER" \\
                        --restart unless-stopped \\
                        -p "$APPLICATION_PORT:8080" \\
                        "$DOCKER_IMAGE"

                    sudo docker ps --filter "name=$DOCKER_CONTAINER"

                    echo "Cleaning up unused dangling application images..."
                    sudo docker image prune -f
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
