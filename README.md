# 📦 Інфраструктура на Terraform для Django в Kubernetes на AWS

Цей репозиторій містить конфігурацію Terraform для створення базової хмарної інфраструктури за допомогою Infrastructure as Code (IaC). Проєкт розгортає Django-застосунок у Kubernetes-кластері AWS EKS із використанням Terraform, Helm, Jenkins, Argo CD та інших сервісів AWS.
Проєкт включає Virtual Private Cloud (VPC) середовище з публічними та приватними підмережами, NAT Gateway, таблиці маршрутизації, Amazon Elastic Container Registry (ECR), RDS/Aurora базу даних та конфігурацію віддаленого бекенду з використанням Amazon S3 і DynamoDB.

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
Перейдіть до модуля бекенду для підготовки конфігурації віддаленого стану:

```bash
cd modules/s3-backend
terraform init
terraform apply
```

### 2. Ініціалізація основної конфігурації
Поверніться до кореня проєкту та ініціалізуйте повне налаштування:

```bash
cd ../../
terraform init
```

### 3. Перегляд запланованих змін
Перед розгортанням перевірте план інфраструктури:

```bash
terraform plan
```

### 4. Розгортання інфраструктури
Застосуйте Terraform план для створення ресурсів:

```bash
terraform apply
```

### 5. Збірка Docker-образу та пуш в ECR

```bash
docker build -t <your-ecr-repo>:latest .
docker push <your-ecr-repo>:latest
```

### 6. Деплой Django Helm-чарту

```bash
cd charts/django-app
helm upgrade --install django-app .
```

### 7. Демонтаж інфраструктури
Для видалення всіх створених ресурсів:
```bash
terraform destroy
```

## 🧪 Перевірка виконання Jenkins Job

### 1. Доступ до Jenkins UI
Після розгортання інфраструктури знайдіть URL адміністратора Jenkins та облікові дані у виводах модуля jenkins:
```bash
terraform output -module=jenkins
```

### 2. Вхід в систему
Увійдіть, використовуючи відображені ім'я користувача та пароль адміністратора (admin / admin123)

### 3. Перевірка Jobs

* Перейдіть до Dashboard → Your Job
* Seed job створиться автоматично завдяки JCasC
* Перевірте, що з'явився пайплайн goit-django-docker
* Запустіть пайплайн вручну або налаштуйте webhook для автоматичного виконання
* Перевірте консольний вивід для кроків збірки та результатів розгортання
* Він оновить Helm реліз автоматично

## 📦 Перевірка результатів розгортання в Argo CD

### 1. Доступ до Argo CD Web UI
Отримайте hostname Argo CD та пароль адміністратора через:
```bash
terraform output -module=argo_cd
```

### 2. Вхід в систему
* Відкрийте hostname у вашому браузері
* Використовуйте admin як ім'я користувача та отриманий пароль
* Альтернативно, отримайте пароль командою:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
```


### 3. Перевірка застосунків
* У UI перейдіть до Applications
* Ви повинні побачити розгорнуті застосунки, такі як django-app
* Argo CD показуватиме статус синхронізації, здоров'я та історію розгортання

### 4. Синхронізація та оновлення
* Натисніть "Sync", щоб застосувати останній стан з Git репозиторію
* Використовуйте "Refresh" для ручної ресинхронізації зі станом кластера
* До Jenkins job: Argo CD застосунок є OutOfSync
* Після Jenkins job: Argo CD застосунок стає Synced

## 🧩 RDS (Aurora / стандарт)
Цей розділ описує, як використовувати модуль Terraform rds для створення бази даних на AWS.
Приклад використання
```hcl
module "rds" {
  source                              = "./modules/rds"
  rds_password                        = var.rds_password
  rds_publicly_accessible             = var.rds_publicly_accessible
  rds_instance_class                  = var.rds_instance_class
  rds_backup_retention_period         = var.rds_backup_retention_period
  rds_use_aurora                      = var.rds_use_aurora
  rds_multi_az                        = var.rds_multi_az
  rds_aurora_engine                   = var.rds_aurora_engine
  rds_aurora_engine_version           = var.rds_aurora_engine_version
  rds_aurora_parameter_group_family   = var.rds_aurora_parameter_group_family
  rds_instance_engine                 = var.rds_instance_engine
  rds_instance_engine_version         = var.rds_instance_engine_version
  rds_instance_parameter_group_family = var.rds_instance_parameter_group_family
}
```

### Опис змінних
| Змінна                                | Опис                                                                             |
| ------------------------------------- | -------------------------------------------------------------------------------- |
| `rds_password`                        | Пароль бази даних (обов'язковий)                                                 |
| `rds_publicly_accessible`             | Чи повинен RDS instance/cluster бути публічно доступним (true/false)             |
| `rds_use_aurora`                      | Використовувати Aurora кластер якщо true;                                        |
| `rds_multi_az`                        | Увімкнути Multi-AZ розгортання                                                   |
| `rds_instance_class`                  | Тип instance для RDS (наприклад, db.t3.micro)                                    |
| `rds_backup_retention_period`         | Період зберігання резервних копій у днях                                         |
| `rds_aurora_engine`                   | Тип движка для Aurora (наприклад, aurora-postgresql)                             |
| `rds_aurora_engine_version`           | Версія движка Aurora (наприклад, 15.3)                                           |
| `rds_aurora_parameter_group_family`   | Сімейство групи параметрів Aurora                                                |
| `rds_instance_engine`                 | Движок для стандартного RDS instance                                             |
| `rds_instance_engine_version`         | Версія движка для стандартного RDS                                               |
| `rds_instance_parameter_group_family` | Сімейство групи параметрів для стандартного RDS                                  |


## Як змінити конфігурацію
Ви можете налаштувати ваше RDS розгортання за допомогою наступних методів:
### Змінити тип бази даних:
Для використання Aurora:
```hcl
rds_use_aurora = true
```

### Для використання стандартного RDS:
```hcl
rds_use_aurora = false
```
### Змінити движок бази даних:
Для Aurora:
```hcl
rds_aurora_engine = "aurora-postgresql"
rds_aurora_engine_version = "15.3"
```
Для стандартного RDS:
```hcl
rds_instance_engine = "postgres"
rds_instance_engine_version = "17.2"
```
Змінити клас instance:
```hcl
rds_instance_class = "db.t3.micro"
```

## Приклад CLI
Ви можете перевизначити будь-яку змінну через командний рядок:
```bashterraform apply -target=module.rds \
  -var="rds_publicly_accessible=true" \
  -var="rds_use_aurora=false" \
  -var="rds_instance_class=db.t4g.micro"
  ```
## 📌 Корисні команди
### Конфігурація локального kubectl:
```bash
aws eks --region us-east-2 update-kubeconfig --name eks-cluster-demo
```
### Оновити kubectl для вашого регіону:
```bashaws eks --region <region> update-kubeconfig --name <eks-cluster-name>
```

### Отримати пароль Argo CD:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
-o jsonpath="{.data.password}" | base64 -d
```
### Збірка та пуш Docker образу в ECR:

* Відкрийте Jenkins (URL з AWS Console)
* Схваліть seed job скрипт під Script Approval
* Створіть та запустіть pipeline job
* Jenkins збере та завантажить Docker образ в ECR

## 🔄 Інтеграція з CD Pipeline
### Доступ до Jenkins та Argo CD
Знайдіть endpoints Jenkins та Argo CD в AWS Console під EC2 → Load Balancers.
### Інтеграція Argo CD
* Argo CD розгортається через Terraform
* Застосунки та Git репозиторії визначені в modules/argo_cd/charts
* Доступ до Argo CD UI (URL з AWS Console)

### Розгортання Django застосунку
* Jenkins запускає розгортання
* До Jenkins job: Argo CD застосунок є OutOfSync
* Після Jenkins job: Argo CD застосунок стає Synced
* Відстежуйте статус розгортання в Argo CD UI

### 📝 Ключові файли
* main.tf – Центральна конфігурація, яка інтегрує всі модулі
* backend.tf – Оголошує налаштування бекенду для зберігання віддаленого стану
* outputs.tf – Експонує корисні виводи з інфраструктури
* README.md – Огляд проєкту та інструкції з виконання

### ❗ Примітки
* ALLOWED_HOSTS має містити DNS ALB
* DEBUG має бути False на проді
* Secrets не комітяться у репозиторій
* Для повного видалення:
```bash
terraform destroy
```

Увага: Переконайтеся, що у вас встановлені всі необхідні залежності: terraform, kubectl, helm, docker, aws-cli