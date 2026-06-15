pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'devarsyf/kusursuz-app:latest'
        K8S_TOKEN_ID = 'k8s-token'
        K8S_API_URL = 'https://10.96.0.1:443' 
    }

    stages {
        stage('Kodu Çek') {
            steps {
                echo 'GitHub\'dan güncel kodlar alınıyor...'
                checkout scm
            }
        }

        stage('İmajı Build Et') {
            steps {
                echo 'Docker imajı lokalde üretiliyor...'
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Kubernetes\'e Sıfır Kesintiyle Deploy Et') {
            steps {
                echo 'Kubernetes\'e lokal imaj ile canlıya çıkılıyor...'
                withCredentials([string(credentialsId: "${K8S_TOKEN_ID}", variable: 'KUBE_TOKEN')]) {
                    sh """
                        kubectl --server=${K8S_API_URL} --token=${KUBE_TOKEN} --insecure-skip-tls-verify=true apply -f k8s.yaml
                        kubectl --server=${K8S_API_URL} --token=${KUBE_TOKEN} --insecure-skip-tls-verify=true rollout status deployment/kusursuz-web-app
                    """
                }
            }
        }
    }
}
