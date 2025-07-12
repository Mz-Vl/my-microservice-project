📦 Lesson 7 — Django Kubernetes Deployment on AWS
Цей проєкт розгортає Django-застосунок у кластері Kubernetes, створеному через Terraform, з використанням Helm-чарту та ECR.

📂 Структура проєкту
lesson-7/
main.tf — підключення всіх модулів
backend.tf — налаштування бекенду Terraform (S3 + DynamoDB)
outputs.tf — виводи ресурсів

modules/
├── s3-backend/
  s3.tf — створення S3 бакета
  dynamodb.tf — створення DynamoDB
  variables.tf — змінні
  outputs.tf — виведення інформації

├── vpc/
  vpc.tf — опис VPC, сабнетів, IGW
  routes.tf — таблиці маршрутів
  variables.tf — змінні
  outputs.tf — виведення

├── ecr/
  ecr.tf — створення репозиторію
  variables.tf — змінні
  outputs.tf — виведення

├── eks/
  eks.tf — створення кластера
  variables.tf — змінні
  outputs.tf — виведення

charts/
└── django-app/
  Chart.yaml — опис Helm-чарту
  values.yaml — параметри образу, сервісу, autoscaler
  templates/
   deployment.yaml — деплой Django
   service.yaml — сервіс для доступу
   hpa.yaml — autoscaler
   configmap.yaml — змінні середовища

README.md — документація проєкту

🌐 Реалізовано
✅ Terraform

Створює EKS кластер

Створює VPC (або використовує існуючу)

Створює ECR для зберігання Docker-образу

Використовує бекенд S3 + DynamoDB для зберігання стейтів

✅ Docker + ECR

Docker-образ Django зібраний локально

Завантажений до ECR через docker push

✅ Helm

Deployment для Django (з образом із ECR)

Service (ClusterIP)

ConfigMap (підтягування змінних середовища)

HPA (масштабування від 2 до 6 при 70% CPU)

Ingress (ALB) для доступу з інтернету

✅ Ingress

Application Load Balancer (ALB)

HTTP 200 підтверджено (сторінка Django віддається)

✅ ConfigMap

змінні середовища перенесені з теми 4

підключені через Helm

🚀 Розгортання
⚠️ Після перевірки обов’язково зробіть terraform destroy, щоб уникнути неочікуваних витрат на AWS!

bash
Copy
Edit
# ініціалізація Terraform
terraform init

# перевірка плану
terraform plan

# створення інфраструктури
terraform apply

# збірка Docker-образу
docker build -t <ecr-repo>:latest .

# пуш Docker-образу
docker push <ecr-repo>:latest

# деплой через Helm
cd lesson-7/charts/django-app
helm upgrade --install django-app .

# перевірка
kubectl get ingress
kubectl get svc
kubectl get pods

# при необхідності
terraform destroy
📝 Примітки
ALLOWED_HOSTS має бути прописаний відповідно до адреси ALB

DEBUG повинен бути вимкнений у production

HPA контролюється через значення у values.yaml
