# Cambiamos a una imagen base de Ubuntu que maneja mejor wkhtmltopdf
FROM ubuntu:22.04

# Evitar que la instalación de paquetes se quede trabada pidiendo zona horaria
ENV DEBIAN_FRONTEND=noninteractive

# Instalar Python, wkhtmltopdf y las dependencias del sistema en un solo paso limpio
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    wkhtmltopdf \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar e instalar las dependencias de Python
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copiar el resto del código del proyecto (tu main.py)
COPY . .

# Exponer el puerto en el que corre FastAPI
EXPOSE 8000

# Comando para arrancar la aplicación usando python3
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]