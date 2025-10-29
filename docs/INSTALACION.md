# 📖 Guía de Instalación Completa

## Requisitos del Sistema

### Hardware Mínimo
- **CPU**: 2 cores (4 recomendados)
- **RAM**: 4GB (8GB recomendado)
- **Disco**: 10GB libres
- **Red**: Conexión a Internet (solo para instalación inicial)

### Software Requerido
- **SO**: Linux (Ubuntu 20.04+, Kali Linux, Debian 11+)
- **Docker**: 20.10+
- **Docker Compose**: 1.29+
- **Hydra**: 9.0+
- **Git**: 2.25+

## Instalación Paso a Paso

### 1. Actualizar el Sistema

```bash
sudo apt update && sudo apt upgrade -y
```

### 2. Instalar Docker y Docker Compose

```bash
# Instalar Docker
sudo apt install -y docker.io docker-compose

# Iniciar Docker
sudo systemctl start docker
sudo systemctl enable docker

# Verificar instalación
docker --version
docker-compose --version
```

### 3. Configurar Permisos de Docker

```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Aplicar cambios (opción 1: cerrar sesión y volver a entrar)
# O ejecutar:
newgrp docker

# Verificar
docker ps
```

### 4. Instalar Hydra

```bash
sudo apt install -y hydra hydra-gtk
hydra -h  # Verificar instalación
```

### 5. Instalar Herramientas Adicionales

```bash
sudo apt install -y \
    git \
    netstat-nat \
    net-tools \
    curl \
    wget \
    vim
```

### 6. Clonar el Repositorio

```bash
cd ~
git clone https://github.com/TU_USUARIO/bruteforce-security-lab.git
cd bruteforce-security-lab
```

### 7. Verificar Estructura

```bash
ls -la
# Deberías ver:
# - docker-compose.yml
# - start-lab.sh
# - hydra-attacks.sh
# - wordlists/
# - web-server/
# - etc.
```

### 8. Dar Permisos a Scripts

```bash
chmod +x *.sh
```

### 9. Iniciar el Laboratorio

```bash
./start-lab.sh
```

Espera 30-60 segundos para que todos los servicios se inicien.

### 10. Verificar Servicios

```bash
./status-lab.sh
```

Todos los contenedores deben mostrar "Up".

## Verificación de Instalación

### Prueba Manual de Servicios

```bash
# SSH
ssh -p 2222 admin@localhost
# Contraseña: admin123
# Luego: exit

# FTP
ftp localhost
# Usuario: admin
# Contraseña: admin123
# Luego: quit

# HTTP
curl http://localhost:5000
# Deberías ver HTML

# HTTP Basic Auth
curl -u admin:admin123 http://localhost:8080
# Deberías ver la página de bienvenida
```

### Prueba con Hydra

```bash
# Prueba rápida SSH
hydra -l admin -p admin123 -s 2222 ssh://localhost

# Si ves "1 valid password found" → ¡Funciona!
```

## Post-Instalación

### Configurar Alias (Opcional)

```bash
# Agregar al ~/.bashrc
echo "alias lab-start='cd ~/bruteforce-security-lab && ./start-lab.sh'" >> ~/.bashrc
echo "alias lab-stop='cd ~/bruteforce-security-lab && ./stop-lab.sh'" >> ~/.bashrc
echo "alias lab-attack='cd ~/bruteforce-security-lab && ./hydra-attacks.sh'" >> ~/.bashrc

# Recargar
source ~/.bashrc

# Ahora puedes usar:
# lab-start
# lab-attack
# lab-stop
```

### Crear Backup

```bash
cd ~
tar -czf bruteforce-lab-backup.tar.gz bruteforce-security-lab/
```

## Solución de Problemas Comunes

### Problema: Docker no inicia

```bash
sudo systemctl status docker
sudo systemctl restart docker
```

### Problema: Puerto ocupado

```bash
# Ver qué usa el puerto
sudo lsof -i :2222

# Matar proceso
sudo kill -9 [PID]

# O cambiar puerto en docker-compose.yml
```

### Problema: Permisos denegados

```bash
sudo chown -R $USER:$USER ~/bruteforce-security-lab
chmod +x ~/bruteforce-security-lab/*.sh
```

### Problema: Contenedor no inicia

```bash
# Ver logs
docker-compose logs nombre_contenedor

# Reconstruir
docker-compose down
docker-compose up -d --build
```

## Desinstalación

```bash
# Detener y eliminar contenedores
cd ~/bruteforce-security-lab
docker-compose down -v

# Eliminar imágenes
docker rmi $(docker images -q)

# Eliminar proyecto
cd ~
rm -rf bruteforce-security-lab
```

## Siguientes Pasos

1. Lee la [Guía de Uso](GUIA_DE_USO.md)
2. Ejecuta tu primer ataque con `./hydra-attacks.sh`
3. Revisa los logs en `logs/`
4. Consulta [Troubleshooting](TROUBLESHOOTING.md) si hay problemas

---

**¿Listo para empezar?** → `./hydra-attacks.sh`
