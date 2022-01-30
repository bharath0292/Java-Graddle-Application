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
        stage("docker build and docker push into nexus"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
                        sh '''
                        docker build -t 34.133.46.164:8083/springapp:${VERSION} .
                        docker login -u admin -p $docker_password  34.133.46.164:8083
                        docker push 34.133.46.164:8083/springapp:${VERSION}
                        docker rmi  34.133.46.164:8083/springapp:${VERSION}
                    '''
                    }
                }
            }
        }
        stage("identifying misconfigs using datree in helm charts"){
            steps{
                script{
                    dir('kubernetes/'){
                        withEnv(['DATREE_TOKEN=ob78dFdkzn74naa6JzZK2n']) {
                            sh 'helm datree test myapp/'
                        }
                    }
                }
            }
        }
        stage("pushing the helm charts to nexus"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
                        dir('kubernetes/'){
                            sh '''
                            helmversion=$(helm show chart  myapp | grep version | cut -d: -f 2 | tr -d ' ')
                            tar -czvf  myapp-${helmversion}.tgz myapp/
                            curl -u admin:$docker_password http://34.133.46.164:8081/repository/helm-hosted/ --upload-file myapp-${helmversion}.tgz -v
                            '''
                        }
                    }
                }
            }
        }
        stage('Deploying application on k8s cluster') {
            steps {
                script{
                    dir('kubernetes/'){
                        withCredentials([kubeconfigFile(credentialsId: 'kubenetes-config', variable: 'KUBECONFIG')]) {
                            sh 'helm upgrade --install --set image.repository="34.133.46.164:8083/springapp" --set image.tag="${VERSION}" myjavaapp myapp/ ' 
                        }
                    }
                }
            }
        }
    }
    post {
		always {
			mail bcc: '', body: "<br>Project: ${env.JOB_NAME} <br>Build Number: ${env.BUILD_NUMBER} <br> URL de build: ${env.BUILD_URL}", cc: '', charset: 'UTF-8', from: '', mimeType: 'text/html', replyTo: '', subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", to: "bharath0292@gmail.com";  
		    }
	    }   
}