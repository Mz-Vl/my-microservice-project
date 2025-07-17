# 📦 Інфраструктура на Terraform для Django в Kubernetes на AWS

Цей репозиторій містить конфігурацію для розгортання Django-застосунку в Kubernetes-кластері AWS EKS із використанням Terraform, Helm, Jenkins, Argo CD та інших сервісів AWS.

## 📁 Структура проєкту

```plaintext
Project/
│
├── main.tf                        # Головний файл для підключення модулів
├── backend.tf                     # Конфігурація бекенду для файлів стану (S3 + DynamoDB)
├── outputs.tf                     # Глобальні виводи ресурсів
│
├── modules/                       # Директорія з усіма модулями
│   ├── s3-backend/                # Модуль для S3 та DynamoDB
│   │   ├── s3.tf                  # Створення S3 bucket
│   │   ├── dynamodb.tf            # Створення таблиці DynamoDB
│   │   ├── variables.tf           # Змінні для S3
│   │   └── outputs.tf             # Виводи для S3 та DynamoDB
│   │
│   ├── vpc/                       # Модуль для VPC
│   │   ├── vpc.tf                 # Створення VPC, підмереж та Internet Gateway
│   │   ├── routes.tf              # Конфігурація таблиці маршрутизації
│   │   ├── variables.tf           # Змінні для VPC
│   │   └── outputs.tf             # Виводи VPC
│   │
│   ├── ecr/                       # Модуль для ECR
│   │   ├── ecr.tf                 # Створення ECR репозиторію
│   │   ├── variables.tf           # Змінні для ECR
│   │   └── outputs.tf             # Вивід URL репозиторію
│   │
│   ├── eks/                       # Модуль для кластера Kubernetes (EKS)
│   │   ├── eks.tf                 # Створення EKS кластера
│   │   ├── aws_ebs_csi_driver.tf  # Встановлення плагіна EBS CSI драйвера
│   │   ├── variables.tf           # Змінні для EKS
│   │   └── outputs.tf             # Виводи для EKS кластера
│   │
│   ├── jenkins/                   # Модуль для встановлення Jenkins через Helm
│   │   ├── jenkins.tf             # Helm реліз для Jenkins
│   │   ├── variables.tf           # Змінні (ресурси, облікові дані, значення)
│   │   ├── providers.tf           # Визначення провайдерів
│   │   ├── values.yaml            # Конфігурація Jenkins
│   │   └── outputs.tf             # Виводи (URL, пароль адміністратора)
│   │
│   ├── rds/                       # Модуль RDS
│   │   ├── rds.tf                 # Створення RDS бази даних
│   │   ├── aurora.tf              # Створення кластера Aurora бази даних
│   │   ├── shared.tf              # Спільні ресурси
│   │   ├── variables.tf           # Змінні (ресурси, облікові дані, значення)
│   │   └── outputs.tf             # Виводи RDS
│   │
│   └── argo_cd/                   # Модуль для встановлення Argo CD через Helm
│       ├── argocd.tf              # Helm реліз для Argo CD
│       ├── variables.tf           # Змінні (версія чарту, неймспейс, URL репо тощо)
│       ├── providers.tf           # Провайдери Kubernetes + Helm
│       ├── values.yaml            # Кастомна конфігурація Argo CD
│       ├── outputs.tf             # Виводи (hostname, початковий пароль адміністратора)
│       └── charts/                # Helm чарт для створення Argo CD застосунків
│           ├── Chart.yaml         # Метадані чарту
│           ├── values.yaml        # Список застосунків, репозиторіїв
│           └── templates/
│               ├── application.yaml    # Шаблон застосунку
│               └── repository.yaml     # Шаблон репозиторію
│
├── charts/                        # Директорія з Helm чартами
│   └── django-app/                # Helm чарт для Django застосунку
│       ├── templates/
│       │   ├── deployment.yaml    # Розгортання Django
│       │   ├── service.yaml       # Сервіс для Django
│       │   ├── configmap.yaml     # Конфігураційна мапа
│       │   └── hpa.yaml           # Горизонтальне автомасштабування
│       ├── Chart.yaml             # Метадані чарту
│       └── values.yaml            # ConfigMap зі змінними середовища
```

## 🛠 Технології

- **Terraform** для керування інфраструктурою
- **Docker + ECR** — контейнеризація Django-застосунку
- **Helm** — деплой сервісів у кластер
- **Jenkins** — CI/CD пайплайни
- **Argo CD** — GitOps деплой додатків
- **PostgreSQL / Aurora** — база даних (за вибором)

## 🚀 Розгортання

### 1. Ініціалізація S3/DynamoDB бекенду

```bash
cd modules/s3-backend
terraform init
terraform apply
```

### 2. Розгортання всієї інфраструктури

```bash
cd ../../
terraform init
terraform plan
terraform apply
```

### 3. Збірка Docker-образу та пуш в ECR

```bash
docker build -t <your-ecr-repo>:latest .
docker push <your-ecr-repo>:latest
```

### 4. Деплой Django Helm-чарту

```bash
cd charts/django-app
helm upgrade --install django-app .
```

## 🧪 CI/CD з Jenkins

1. **Отримай вихідні дані:**
   ```bash
   terraform output -module=jenkins
   ```

2. **Увійди в Jenkins** через ALB URL (`admin` / `admin123`)

3. **Seed job** створиться автоматично завдяки JCasC

4. **Перевір**, що з'явився пайплайн `goit-django-docker`

5. **Запусти** — він оновить Helm реліз автоматично

## 📦 Argo CD

1. **Отримай URL та пароль:**
   ```bash
   terraform output -module=argo_cd
   ```

2. **Відкрий Web UI** → Увійди як `admin`

3. **Побачиш додаток** `django-app` → натисни **Sync**

## 🧩 RDS (Aurora / стандарт)

Модуль `rds` дозволяє обрати між Aurora та стандартною PostgreSQL:

```hcl
module "rds" {
  source = "./modules/rds"
  use_aurora = true
  ...
}
```

### Типи баз:

| Параметр | Опис |
|----------|------|
| `use_aurora` | `true` → Aurora, `false` → стандарт |
| `multi_az` | Висока доступність |
| `engine_version` | Версія (наприклад `15.3` або `17.2`) |
| `instance_class` | Розмір екземпляра RDS |

## 📌 Корисні команди

**Оновити kubectl:**
```bash
aws eks --region <region> update-kubeconfig --name <eks-cluster-name>
```

**Отримати пароль Argo CD:**
```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```

## ❗ Примітки

- `ALLOWED_HOSTS` має містити DNS ALB
- `DEBUG` має бути `False` на проді
- Secrets не комітяться у репозиторій
- Для повного видалення:
  ```bash
  terraform destroy
  ```

---

> **Увага:** Переконайтеся, що у вас встановлені всі необхідні залежності: `terraform`, `kubectl`, `helm`, `docker`, `aws-cli`