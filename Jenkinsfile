pipeline{
    agent any
    stages{
        stage("sonar quality check"){
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar_token', installationName: 'sonarserver') {
                        sh 'chmod +x gradlew'
                        sh './gradlew --build-cache --warning-mode all --info sonarqube'
                    }          
                }   
            }
            
            
            }
        }
}