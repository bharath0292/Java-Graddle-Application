pipeline{
    agent any
    environment{
        VERSION = "${env.BUILD_ID}" 
    }
    stages{
        stage("sonar quality check"){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar_token', installationName: 'sonarserver') {
                        sh 'chmod +x gradlew'
                        sh './gradlew --build-cache --warning-mode all --info sonarqube'
                    }

                    timeout(time: 1, unit: 'HOURS') {
                      def qg = waitForQualityGate()
                      if (qg.status != 'OK') {
                           error "Pipeline aborted due to quality gate failure: ${qg.status}"
                      }
                    }          
                }   
            }           
            }
        stage("docker build and docker push"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
                        sh '''
                        docker build -t 34.133.46.164:8083/springapp:${VERSION}
                        docker login -u admin -p $docker_password  34.133.46.164:8083
                        docker push 34.133.46.164:8083/springapp:${VERSION}
                        docker rmi  34.133.46.164:8083/springapp:${VERSION}
                    '''
                    }
                }
            }
        }
        }
}