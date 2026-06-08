# Usar una imagen base oficial de Python ligera
FROM python:3.11-slim

# Instalar wkhtmltopdf y sus dependencias necesarias en Linux
RUN apt-get update && apt-get install -y \
    wkhtmltopdf \
    libssl-dev \
    build-essential \
    xfonts-75dpi \
    xfonts-base \
    && rm -rf /var/lib/apt/lists/*

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar e instalar las dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto del código del proyecto (tu main.py)
COPY . .

# Exponer el puerto en el que corre FastAPI
EXPOSE 8000

# Comando para arrancar la aplicación
CMD ["uvicorn", "main:app", "host", "0.0.0.0", "port", "8000"]