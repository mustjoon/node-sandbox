pipeline {
   tools {nodejs "node"}
  agent any
    environment {
    registry = "mustjoon/hackathon-starter"
    registryCredential = 'dockerhub'
    dockerImage = ''
    CONTAINER_NAME = "hack"
  }
 
    
 
    
  stages {
        
    stage('Cloning Git') {
      steps {
        git 'https://github.com/mustjoon/node-sandbox'
      }
    }
        
    stage('Install dependencies') {
      steps {
        sh 'npm install'
      }
    }
     
    stage('Test') {
      steps {
         sh 'OPENSHIFT_NODEJS_PORT=9000 npm test'
      }
    }

      stage('Building image') {
      steps{
        script {
          VERSION = sh("node -p `require('./package.json').version`")
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
          VERSION = sh("node -p `require('./package.json').version`")
          sh("docker network inspect home >/dev/null 2>&1 || \
              docker network create --driver bridge home")
          sh("docker pull mustjoon/hackathon-starter:$VERSION")
          sh("(docker stop $CONTAINER_NAME > /dev/null && echo Stopped container $CONTAINER_NAME && \
            docker rm $CONTAINER_NAME ) 2>/dev/null || true")
          sh("docker start mongo || docker run -d --publish 27017:27017 --network 'home'  --name 'mongo' mongo:3.6")
          sh("docker run -d --network 'home' --publish 8085:8085 --name='$CONTAINER_NAME' --env 'MONGODB_URI=mongodb://mongo:27017/test' --env 'OPENSHIFT_NODEJS_PORT=8085' mustjoon/hackathon-starter:$VERSION")
         
        }
      }
    }      
  }
}