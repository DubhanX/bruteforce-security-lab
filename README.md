# 🔐 Laboratorio de Seguridad: Ataques de Fuerza Bruta con Hydra

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Compose-blue.svg)](https://www.docker.com/)
[![Security](https://img.shields.io/badge/Security-Educational-red.svg)](https://owasp.org/)

> **⚠️ ADVERTENCIA**: Este proyecto es **EXCLUSIVAMENTE** para fines educativos. No usar en sistemas sin autorización explícita.

## 📚 Descripción

Proyecto universitario que demuestra vulnerabilidades de autenticación (OWASP A07:2021) mediante ataques de fuerza bruta en un entorno local controlado con Docker.

## 🎯 Objetivos

- ✅ Implementar ambiente vulnerable con 6 servicios
- ✅ Ejecutar ataques automatizados con Hydra
- ✅ Analizar efectividad según protocolo
- ✅ Proponer medidas de mitigación

## 🚀 Instalación Rápida

```bash
# Clonar repositorio
git clone https://github.com/TU_USUARIO/bruteforce-security-lab.git
cd bruteforce-security-lab

# Iniciar servicios
./start-lab.sh

# Ejecutar ataques
./hydra-attacks.sh
```

## 🎓 Servicios Vulnerables

| Servicio | Puerto | Usuario | Contraseña |
|----------|--------|---------|------------|
| SSH Node 1 | 2222 | admin | admin123 |
| SSH Node 2 | 2223 | user | password123 |
| FTP | 21 | admin | admin123 |
| HTTP Basic | 8080 | admin | admin123 |
| Flask App | 5000 | admin | admin123 |
| MySQL | 3306 | admin | admin123 |

## 💻 Uso Básico

```bash
./start-lab.sh      # Iniciar
./status-lab.sh     # Ver estado
./hydra-attacks.sh  # Atacar
./stop-lab.sh       # Detener
```

## 📄 Licencia

MIT License - Solo para fines educativos

## ⚖️ Legal

**USO EDUCATIVO ÚNICAMENTE**. El acceso no autorizado a sistemas es ilegal.
