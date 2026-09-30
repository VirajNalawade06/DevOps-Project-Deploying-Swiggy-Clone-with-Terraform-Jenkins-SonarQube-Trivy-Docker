pipeline {
    agent any

    tools {
        jdk 'jdk21'
        nodejs 'node26'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {
        stage('Clean workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout from Git') {
            steps {
                git 'https://github.com/deepeshmlgupta/DevOps_Swiggy.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh '''${SCANNER_HOME}/bin/sonar-scanner -Dsonar.projectName=Swiggy -Dsonar.projectKey=Swiggy'''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('OWASP FS Scan') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('TRIVY FS Scan') {
            steps {
                sh 'trivy fs . > trivyfs.txt'
            }
        }

        stage('Docker Build & Push') {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker-creds', toolName: 'docker') {
                        sh 'docker build -t swiggy .'
                        sh 'docker tag swiggy deepesh/swiggy:latest'
                        sh 'docker push deepesh/swiggy:latest'
                    }
                }
            }
        }

        stage('TRIVY') {
            steps {
                sh 'trivy image deepesh/swiggy:latest > trivy.txt'
            }
        }

        stage('Deploy to container') {
            steps {
                sh 'docker run -d --name swiggy -p 3000:3000 deepesh/swiggy:latest'
            }
        }
    }
}
