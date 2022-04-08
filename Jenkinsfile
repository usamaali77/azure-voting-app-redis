pipeline {
   agent any

   stages {
      stage('Verify Branch') {
         steps {
            echo "$GIT_BRANCH"
         }
      }
      stage('Docker Build') {
         steps {
            sh(script: 'docker images -a')
            sh(script: """
               cd azure-vote/
               docker images -a
               docker build -t jenkins-pipeline .
               docker images -a
               cd ..
            """)
         }
      }
      stage('Start test app') {
         steps {
            sh(script: """
               docker-compose up -d
               ./scripts/test_container.sh
            """)
         }
         post {
            success {
               echo "App started successfully :)"
            }
            failure {
               echo "App failed to start :("
            }
         }
      }
      stage('Run Tests') {
         steps {
            sh(script: """
               python3 -m pytest ./tests/test_sample.py
            """)
         }
      }
      stage('Stop test app') {
         steps {
            sh(script: """
               docker-compose down
            """)
         }
      }
      stage('Push Container') {
         steps {
            echo "Workspace is $WORKSPACE"
            dir("$WORKSPACE/azure-vote") {
               script {
                  docker.withRegistry('https://index.docker.io/v1/', 'DockerHub'){
                     def image = docker.build('usama700/jenkins-course:latest')
                     image.push()
                  }
               }
            }
         }
      }
      stage ('Container Scanning') {
         parallel {
            stage('Scan Container with Trivy'){
               steps {
                  sh(script: """
                     trivy image usama700/jenkins-course
                  """)
               }
            }
            stage('Run Anchore') {
               steps {
                  anchore name: "anchore_images", bailOnFail: false, bailOnPluginFail: false
               }
            }

         }
      }
   }
}
