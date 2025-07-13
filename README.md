📦 Lesson 7 — Django Kubernetes Deployment on AWS
Цей проєкт розгортає Django-застосунок у кластері Kubernetes, створеному через Terraform, з використанням Helm-чарту та ECR.

```plaintext
lesson-8-9/
├── backend.tf                 # Налаштування бекенду Terraform (S3 + DynamoDB)
├── main.tf                    # Підключення модулів
├── outputs.tf                 # Виводи ресурсів
├── terraform.tfvars           # Значення змінних
├── variables.tf               # Змінні
├── jenkins-storageclass.yaml  # StorageClass для Jenkins
├── ebs-csi-driver-policy.json # IAM policy для EBS CSI Driver

modules/
├── s3-backend/
│   ├── s3.tf
│   ├── dynamodb.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── vpc/
│   ├── vpc.tf
│   ├── routes.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── ecr/
│   ├── ecr.tf
│   ├── variables.tf
│   └── outputs.tf
│
├── eks/
│   ├── eks.tf
│   ├── aws_ebs_csi_driver.tf   # Драйвер EBS
│   ├── variables.tf
│   └── outputs.tf
│
├── jenkins/
│   ├── jenkins.tf              # Helm release Jenkins
│   ├── configmap.yaml          # Jenkins ConfigMap
│   ├── values.yaml             # Jenkins values для Helm
│   ├── providers.tf            # Kubernetes/Helm provider
│   ├── variables.tf
│   └── outputs.tf
│
└── argo_cd/
    ├── argo_cd.tf              # Helm release Argo CD
    ├── providers.tf            # (спільно з Jenkins або окремо)
    ├── values.yaml             # Аргумент values для ArgoCD
    ├── variables.tf
    ├── outputs.tf
    └── charts/
        ├── Chart.yaml
        ├── values.yaml         # Список apps, репозиторіїв
        └── templates/
            ├── application.yaml
            └── repository.yaml

charts/
├── django-app/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│       ├── deployment.yaml
│       ├── service.yaml
│       ├── hpa.yaml
│       ├── configmap.yaml
│       └── django-ingress.yaml
│
└── jenkins/
    ├── Chart.yaml
    └── values.yaml

docker-django/
└── app/
    ├── __init__.py
    ├── asgi.py
    ├── settings.py
    ├── urls.py
    └── wsgi.py

k8s/
└── ebs-storageclass.yaml       # Додаткові K8s YAML-маніфести (якщо треба)
```

README.md — документація проєкту

✅ Реалізовано
⚙️ Terraform
EKS кластер для Kubernetes

ECR репозиторій

VPC + сабнети + Internet Gateway

S3 bucket + DynamoDB для terraform.tfstate

🐳 Docker + ECR
Docker-образ Django

Публікація образу до ECR

📦 Helm
Deployment + Service для Django

ConfigMap для змінних оточення

HPA (масштабування від 2 до 6)

Ingress (ALB) для зовнішнього доступу

🔧 Jenkins (CI/CD)
Jenkins деплой через Helm-чарт

Плагіни: git, job-dsl, github, docker-workflow, kubernetes, configuration-as-code

Jenkins Configuration as Code (JCasC)

Seed job для автоматичного створення пайплайну з GitHub-репозиторію

Облікові дані GitHub зберігаються в Kubernetes Secret

🚀 Деплой
bash
Copy
Edit
# Ініціалізація Terraform
terraform init

# Перевірка
terraform plan

# Створення інфраструктури
terraform apply
bash
Copy
Edit
# Збірка та пуш Docker-образу
docker build -t <ecr-repo>:latest .
docker push <ecr-repo>:latest
bash
Copy
Edit
# Деплой Django Helm-чарту
cd charts/django-app
helm upgrade --install django-app .

# Деплой Jenkins
cd modules/jenkins
helm upgrade --install jenkins oci://registry-1.docker.io/bitnamicharts/jenkins -f values.yaml -n jenkins --create-namespace
🔁 Перевірка CI/CD
Зайти в Jenkins: http://<ALB-address>:80

Авторизуватись як admin / admin123

Seed job має з’явитись автоматично (JCasC)

Перевірити, що створено goit-django-docker pipeline job

Запустити pipeline → автоматичне оновлення Helm деплою

⚠️ Примітки
ALLOWED_HOSTS має включати DNS-адресу ALB

DEBUG=False у production

Secrets не пушаться у GitHub

Для видалення ресурсів:

bash
Copy
Edit
terraform destroy