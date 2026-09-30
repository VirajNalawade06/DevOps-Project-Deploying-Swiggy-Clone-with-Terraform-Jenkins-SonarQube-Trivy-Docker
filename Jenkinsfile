pipeline {
    agent any

    tools {
        jdk 'jdk21'
        nodejs 'node20'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
        IMAGE_NAME = 'viraj8956/swiggy:latest'
    }

    stages {

        stage('Clean workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout from Git') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/VirajNalawade06/DevOps-Project-Deploying-Swiggy-Clone-with-Terraform-Jenkins-SonarQube-Trivy-Docker.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh '''
                        ${SCANNER_HOME}/bin/sonar-scanner \
                        -Dsonar.projectName=Swiggy \
                        -Dsonar.projectKey=Swiggy
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate(
                        abortPipeline: false,
                        credentialsId: 'Sonar-token'
                    )
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm ci'
            }
        }

        stage('OWASP FS Scan') {
            steps {
                dependencyCheck(
                    additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit',
                    odcInstallation: 'DP-Check'
                )

                dependencyCheckPublisher(
                    pattern: '**/dependency-check-report.xml'
                )
            }
        }

        stage('TRIVY FS Scan') {
            steps {
                sh 'trivy fs . > trivyfs.txt'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-creds',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {
                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login \
                            -u "$DOCKER_USERNAME" \
                            --password-stdin

                        docker build -t "$IMAGE_NAME" .

                        docker push "$IMAGE_NAME"

                        docker logout
                    '''
                }
            }
        }

        stage('TRIVY Image Scan') {
            steps {
                sh 'trivy image "$IMAGE_NAME" > trivy.txt'
            }
        }

        stage('Deploy to container') {
            steps {
                sh '''
                    docker rm -f swiggy 2>/dev/null || true

                    docker run -d \
                        --name swiggy \
                        --restart unless-stopped \
                        -p 3000:80 \
                        "$IMAGE_NAME"
                '''
            }
        }
    }
}
