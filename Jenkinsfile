pipeline {
  tools {nodejs "node"}
  agent any
    environment {
    registryCredential = 'dockerhub'
    dockerImage = ''
    PACKAGE_JSON = readJSON file: './package.json'
    HOST = "167.71.56.231"
    VERSION = "${PACKAGE_JSON['version']}"
    APP_NAME = "${PACKAGE_JSON['name']}"
    CONTAINER_NAME = "${APP_NAME}"
    PORT = "8085"
    GIT_URL = "${PACKAGE_JSON['repository']['url']}"
    registry = "mustjoon/$APP_NAME"
  }
 
    
 
    
  stages {

    stage('Setup') {
      steps {
        script {
          git "$GIT_URL"
        }
        script {
          sh ('npm install')
        }
       
      }
    }
     
    stage('Test') {
      steps {
         sh 'PORT=9000 npm test'
      }
    }

      stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":$VERSION"
        }
      }
    }
    stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }      
    stage('Deploy to Server') {
      steps{
        script {
          sh("docker network inspect home >/dev/null 2>&1 || \
              docker network create --driver bridge home")
          sh("docker pull $registry:$VERSION")
          sh("(docker stop $CONTAINER_NAME > /dev/null && echo Stopped container $CONTAINER_NAME && \
            docker rm $CONTAINER_NAME ) 2>/dev/null || true")
          sh("docker start mongo || docker run -d --publish 27017:27017 --network 'home'  --name 'mongo' mongo:3.6")
          sh("docker run -d --health-cmd='curl -f http://$HOST:$PORT/health-check'  --health-interval=5s  --network 'home' --publish $PORT:$PORT --name='$CONTAINER_NAME' --env 'MONGODB_URI=mongodb://mongo:27017/test' --env 'OPENSHIFT_NODEJS_PORT=8085' $registry:$VERSION")
         
        }
      }
    }
     stage('Check that currently running version is correct') {
     
        steps{
          def retryAttempt = 0
           retry(2) {
              script {
                if (retryAttempt > 0) {
                    sleep(1000 * 2 + 2000 * retryAttempt)
                }
                sh("bash ./scripts/health-check.sh -v '$VERSION' -h '$HOST' -p '$PORT'")
              }
           }
        }
     }
  }
}