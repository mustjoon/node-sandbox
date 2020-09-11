pipeline {
    environment {
    registry = "mustjoon/hackathon-starter"
    registryCredential = 'dockerhub'
    dockerImage = ''
    
  }
  agent any
    
  tools {nodejs "node"}
    
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
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
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
          sh("docker network create home")
          sh("docker pull mustjoon/hackathon-starter:$BUILD_NUMBER")
          sh("docker kill hack")
          sh("docker rm hack")
          sh("docker run -d --publish 27017:27017 --network 'home'  --name 'mongo' mongo:3.6")
          sh("docker run -d --network 'home' --publish 8085:8085 --name='hack' --env 'MONGODB_URI=mongodb://mongo:27017/test' mustjoon/hackathon-starter:$BUILD_NUMBER")
         
        }
      }
    }      
  }
}