pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'devarsyf/kusursuz-app:latest'
        CREDENTIALS_ID = 'docker-hub-credentials'
        K8S_TOKEN_ID = 'k8s-token'
        // Kubernetes API Server'ın adresi (İçeriden konuştuğumuz için standart servis IP'si)
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
                echo 'Docker imajı üretiliyor...'
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Docker Hub\'a Gönder') {
            steps {
                echo 'Docker Hub\'a güvenli login yapılıp imaj pushlanıyor...'
                withCredentials([usernamePassword(credentialsId: "${CREDENTIALS_ID}", passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Kubernetes\'e Sıfır Kesintiyle Deploy Et') {
            steps {
                echo 'Kubernetes Token ile RBAC doğrulaması yapılıyor ve canlıya çıkılıyor...'
                withCredentials([string(credentialsId: "${K8S_TOKEN_ID}", variable: 'KUBE_TOKEN')]) {
                    // Jenkins konteyneri içinden K8s API'ye direkt emir gönderiyoruz
                    // --insecure-skip-tls-verify ile sertifika sorunlarını kökten eliyoruz, çünkü zaten cluster içindeyiz!
                    sh """
                        kubectl --server=${K8S_API_URL} --token=${KUBE_TOKEN} --insecure-skip-tls-verify=true apply -f k8s.yaml
                        kubectl --server=${K8S_API_URL} --token=${KUBE_TOKEN} --insecure-skip-tls-verify=true rollout status deployment/kusursuz-web-app
                    """
                }
            }
        }
    }
}
