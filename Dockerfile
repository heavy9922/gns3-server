FROM ubuntu:20.04

# Preconfigurar el entorno para evitar interacciones
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    software-properties-common \
    supervisor \
    git \
    python3 \
    python3-pip \
    python3-setuptools \
    libffi-dev \
    libssl-dev \
    tzdata \
    && apt-get clean

# Establecer zona horaria
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# Instalar dependencias adicionales para Python 3.8
RUN pip3 install --upgrade pip setuptools wheel \
    && pip3 install importlib_resources

# Clonar y configurar el servidor GNS3
RUN git clone https://github.com/GNS3/gns3-server.git /opt/gns3-server \
    && cd /opt/gns3-server \
    && pip3 install -r requirements.txt \
    && python3 setup.py install \
    && pip3 install .

# Exponer el puerto por defecto de GNS3 Server
EXPOSE 3080

# Establecer el directorio de trabajo
WORKDIR /opt/gns3-server

# Ejecutar el servidor GNS3
CMD ["gns3server"]
