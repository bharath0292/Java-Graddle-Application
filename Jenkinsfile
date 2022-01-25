pipeline{
    agent any
    stages{
        stages("sonar quality check"){
            agent{
                docker {
                    image 'openjdk:11'
                }
            }
            script{
                withSonarQubeEnv(credentialsId: 'sonar_token', installationName: 'sonarserver') {
                    sh 'chmod +x gradlew'
                    sh './gradlew sonarqube'
                }          
            }
            
            }
        }
}