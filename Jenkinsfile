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

        stage('İmji Host Docker Üzerinde Build Et') {
            steps {
                echo 'İmaj, Kubernetes\'in erişebileceği ana makine Docker\'ı üzerinde üretiliyor...'
                // Başına sudo koyarak ana makinenin Docker soketine tam yetkiyle vurduruyoruz
                sh "sudo docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Kubernetes\'e Sıfır Kesintiyle Deploy Et') {
            steps {
                echo 'Kubernetes\'e lokal imaj ile canlıya çıkılıyor...'
                withCredentials([string(credentialsId: "${K8S_TOKEN_ID}", variable: 'KUBE_TOKEN')]) {
                    sh """
                        kubectl --server=${K8S_API_URL} --token=${KUBE_TOKEN} --insecure-skip-tls-verify=true apply -f k8s.yaml
                        echo 'Podlarin saglikli sekilde ayaga kalkmasi bekleniyor...'
                        kubectl --server=${K8S_API_URL} --token=${KUBE_TOKEN} --insecure-skip-tls-verify=true rollout status deployment/kusursuz-web-app --timeout=60s
                    """
                }
            }
        }
    }
}
