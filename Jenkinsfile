pipeline {
  agent any

  parameters {
    choice(name: 'ENV', choices: ['dev'], description: 'Target environment')
    booleanParam(name: 'DESTROY', defaultValue: false, description: 'Destroy infrastructure instead of apply')
  }

  environment {
    TF_VAR_region = 'us-east-1'
    AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
    AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/shedytech/terraform-ec2-vpc-jenkins.git', branch: 'main'
      }
    }

    stage('Init Terraform') {
      steps {
        sh 'terraform init'
      }
    }

    stage('Select Environment') {
      steps {
        script {
          env.TFVARS_FILE = "${params.ENV}.tfvars"
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        sh "terraform plan -var-file=${env.TFVARS_FILE}"
      }
    }

    stage('Approval for Non-Dev') {
      when {
        expression { params.ENV != 'dev' && !params.DESTROY }
      }
      steps {
        timeout(time: 5, unit: 'MINUTES') {
          input message: "Approve apply to ${params.ENV.toUpperCase()}?", ok: 'Apply'
        }
      }
    }

    stage('Terraform Apply/Destroy') {
      steps {
        script {
          if (params.DESTROY) {
            sh "terraform destroy -auto-approve -var-file=${env.TFVARS_FILE}"
          } else {
            sh "terraform apply -auto-approve -var-file=${env.TFVARS_FILE}"
          }
        }
      }
    }
  }

  post {
    success {
      echo "Terraform operation for ${params.ENV} completed successfully."
    }
    failure {
      echo "Terraform failed for ${params.ENV}."
    }
  }
}
