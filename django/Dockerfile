FROM python:3.13-alpine
RUN apk add --no-cache \
    curl \
    build-base \
    libpq \
    postgresql-dev \
    musl-dev \
    gcc \
    libffi-dev \
    openssl-dev

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]