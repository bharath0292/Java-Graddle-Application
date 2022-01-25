pipeline{
    agent any
    stages{
        stage("sonar quality check"){
            agent{
                docker {
                    image 'openjdk:11'
                }
            }
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar_token', installationName: 'sonarserver') {
                        sh 'chmod +x gradlew'
                        sh './gradlew build --warning-mode all'
                    }          
                }   
            }
            
            
            }
        }
}