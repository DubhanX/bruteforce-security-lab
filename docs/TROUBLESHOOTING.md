# 🔧 Guía de Solución de Problemas

## Índice
1. [Problemas de Docker](#problemas-de-docker)
2. [Problemas de Red](#problemas-de-red)
3. [Problemas con Hydra](#problemas-con-hydra)
4. [Problemas de Permisos](#problemas-de-permisos)
5. [Problemas de Servicios](#problemas-de-servicios)

---

## Problemas de Docker

### Error: "Cannot connect to the Docker daemon"

**Síntoma**: Al ejecutar comandos Docker aparece error de conexión.

**Solución**:
```bash
# Verificar estado
sudo systemctl status docker

# Iniciar Docker
sudo systemctl start docker

# Habilitar en inicio
sudo systemctl enable docker

# Verificar
docker ps
```

### Error: "Permission denied" al ejecutar Docker

**Síntoma**: Necesitas usar `sudo` para comandos Docker.

**Solución**:
```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Opción 1: Cerrar sesión y volver a entrar
# Opción 2: Ejecutar
newgrp docker

# Verificar
docker ps  # Sin sudo
```

### Error: "Port is already allocated"

**Síntoma**: El puerto ya está en uso por otro proceso.

**Solución**:
```bash
# Ver qué proceso usa el puerto (ejemplo: 2222)
sudo lsof -i :2222
sudo netstat -tlnp | grep 2222

# Matar el proceso
sudo kill -9 [PID]

# O cambiar el puerto en docker-compose.yml
nano docker-compose.yml
# Cambiar "2222:2222" a "2224:2222" por ejemplo
```

### Error: Contenedores no inician

**Síntoma**: `docker-compose ps` muestra contenedores "Restarting" o "Exited".

**Solución**:
```bash
# Ver logs del contenedor problemático
docker-compose logs nombre_contenedor

# Ejemplo:
docker-compose logs lab_ssh_server

# Reconstruir desde cero
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

---

## Problemas de Red

### No puedo conectarme a los servicios

**Síntoma**: `telnet localhost 2222` falla o timeout.

**Diagnóstico**:
```bash
# Verificar que los contenedores estén corriendo
docker-compose ps

# Verificar puertos abiertos
netstat -tlnp | grep -E '(2222|21|8080|5000|3306)'

# Verificar firewall
sudo ufw status

# Verificar logs
docker-compose logs
```

**Solución**:
```bash
# Si firewall está bloqueando
sudo ufw allow 2222/tcp
sudo ufw allow 21/tcp
sudo ufw allow 8080/tcp
sudo ufw allow 5000/tcp
sudo ufw allow 3306/tcp

# Reiniciar servicios
docker-compose restart
```

### Error de red de Docker

**Síntoma**: "network bruteforce-lab_lab_network not found"

**Solución**:
```bash
# Limpiar redes
docker network prune

# Recrear
docker-compose down
docker-compose up -d
```

---

## Problemas con Hydra

### Hydra no encuentra credenciales

**Síntoma**: "0 valid passwords found" cuando debería encontrar.

**Diagnóstico**:
```bash
# 1. Verificar que el servicio esté activo
telnet localhost 2222
# Ctrl+] luego quit

# 2. Verificar credenciales en wordlist
cat wordlists/users.txt | grep admin
cat wordlists/passwords.txt | grep admin123

# 3. Probar manualmente
ssh -p 2222 admin@localhost
# Si funciona manualmente pero no con Hydra, sigue...
```

**Solución**:
```bash
# Usar modo verbose para ver cada intento
hydra -V -l admin -p admin123 -s 2222 ssh://localhost

# Verificar sintaxis del comando
# Para SSH:
hydra -L wordlists/users.txt -P wordlists/passwords.txt -s 2222 ssh://localhost

# Para HTTP Form:
hydra -L wordlists/users.txt -P wordlists/passwords.txt \
      -s 5000 localhost \
      http-post-form "/login:username=^USER^&password=^PASS^:incorrecta"
```

### Hydra muy lento

**Síntoma**: Tarda mucho tiempo en probar combinaciones.

**Solución**:
```bash
# Aumentar threads (con cuidado)
hydra -t 8 -L users.txt -P passwords.txt ssh://localhost -s 2222

# Pero NO usar demasiados threads (max 16 recomendado)
# Puede causar que el servicio rechace conexiones
```

### Error: "Hydra not found"

**Solución**:
```bash
sudo apt update
sudo apt install -y hydra
hydra -h
```

---

## Problemas de Permisos

### Error: "Permission denied" en scripts

**Síntoma**: `./start-lab.sh: Permission denied`

**Solución**:
```bash
chmod +x *.sh
chmod +x start-lab.sh stop-lab.sh hydra-attacks.sh status-lab.sh
```

### Error: "Cannot write to log file"

**Síntoma**: No se crean archivos en `logs/`

**Solución**:
```bash
mkdir -p logs
chmod 777 logs
```

---

## Problemas de Servicios

### SSH no acepta conexiones

**Diagnóstico**:
```bash
# Ver logs del contenedor SSH
docker-compose logs lab_ssh_server

# Entrar al contenedor
docker exec -it lab_ssh_server /bin/bash
# Dentro: verificar que sshd esté corriendo
ps aux | grep ssh
```

**Solución**:
```bash
# Reiniciar contenedor
docker-compose restart lab_ssh_server

# Si persiste, recrear
docker-compose stop lab_ssh_server
docker-compose rm lab_ssh_server
docker-compose up -d lab_ssh_server
```

### Flask App no responde

**Diagnóstico**:
```bash
# Ver logs
docker-compose logs lab_custom_app

# Verificar que esté corriendo
curl http://localhost:5000
```

**Solución**:
```bash
# La app Flask puede tardar en iniciar
# Esperar 30-60 segundos después de docker-compose up

# Si no inicia, reconstruir
docker-compose build lab_custom_app
docker-compose up -d lab_custom_app

# Ver logs en tiempo real
docker-compose logs -f lab_custom_app
```

### MySQL no acepta conexiones

**Síntoma**: "Can't connect to MySQL server"

**Solución**:
```bash
# MySQL tarda en inicializar la primera vez
# Ver logs
docker-compose logs lab_mysql_db

# Esperar a ver: "mysqld: ready for connections"

# Puede tardar 1-2 minutos en la primera ejecución

# Probar conexión
mysql -h 127.0.0.1 -u admin -padmin123 -e "SELECT 1;"
```

### FTP no funciona con Hydra

**Síntoma**: Hydra falla con FTP pero funciona manualmente.

**Solución**:
```bash
# FTP en modo pasivo puede causar problemas
# Usar modo activo con -e nsr
hydra -L wordlists/users.txt -P wordlists/passwords.txt \
      ftp://localhost -e nsr

# O verificar que los puertos pasivos estén abiertos
netstat -tlnp | grep -E '(21100|21110)'
```

---

## Comandos Útiles para Diagnóstico

```bash
# Ver todos los contenedores
docker ps -a

# Ver uso de recursos
docker stats

# Ver redes
docker network ls

# Ver logs de todos los servicios
docker-compose logs

# Logs en tiempo real
docker-compose logs -f

# Reiniciar todo
docker-compose restart

# Limpiar todo y empezar de nuevo
docker-compose down -v
docker system prune -a
./start-lab.sh
```

---

## Resetear Completamente el Laboratorio

Si nada funciona, resetea todo:

```bash
# 1. Detener y eliminar todo
cd ~/bruteforce-security-lab
docker-compose down -v

# 2. Eliminar imágenes
docker rmi $(docker images -q)

# 3. Limpiar sistema Docker
docker system prune -a -f

# 4. Eliminar y reclonar proyecto
cd ~
rm -rf bruteforce-security-lab
git clone https://github.com/TU_USUARIO/bruteforce-security-lab.git
cd bruteforce-security-lab

# 5. Dar permisos
chmod +x *.sh

# 6. Iniciar de nuevo
./start-lab.sh
```

---

## Obtener Ayuda

Si el problema persiste:

1. **Revisa los logs**: `docker-compose logs > debug.log`
2. **Verifica versiones**: 
   ```bash
   docker --version
   docker-compose --version
   hydra -h
   ```
3. **Abre un Issue en GitHub** con:
   - Descripción del problema
   - Logs relevantes
   - Output de `docker-compose ps`
   - Tu sistema operativo y versión

---

**¿Problema resuelto?** → Vuelve a la [Guía de Uso](GUIA_DE_USO.md)
