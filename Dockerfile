FROM python:3.10-slim-bookworm AS builder
WORKDIR /build
RUN apt-get update && apt-get install -y build-essential git && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# -----------------------------
FROM python:3.10-slim-bookworm
WORKDIR /app

# Ensure logs are sent straight to terminal without buffering
ENV PYTHONUNBUFFERED=1 

RUN apt-get update && apt-get install -y libglib2.0-0 libgl1 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local /usr/local
COPY . .

EXPOSE 8080

# It is safer to use the list form for CMD
CMD ["python", "app.py"]