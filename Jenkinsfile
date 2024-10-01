pipeline {
agent {label 'iac'}

// Ensure environment variables are set as secret text type //
environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
}
stages{
  stage('Terraform Init'){
    steps {
	    dir('./gitops') {
                       sh '/usr/local/bin/terraform init'
        }
    }
  }
  stage('Terraform Plan'){
    steps {
	    dir('./gitops') {
                       sh '/usr/local/bin/terraform plan'
        }
    }
  }
  stage('Approval'){
    when { branch 'main'}
    steps {
      script {
         waitUntil {
           fileExists('dummyfile')
         }
      }
    }
  }
  stage('Terraform Apply'){
    steps {
	    dir('./gitops') {
                       sh '/usr/local/bin/terraform apply -auto-approve'
        }
    }
  }
}
}
