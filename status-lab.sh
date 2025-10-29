#!/bin/bash
echo "📊 Estado de los servicios:"
echo ""
docker-compose ps
echo ""
echo "🔍 Puertos en uso:"
netstat -tlnp 2>/dev/null | grep -E '(2222|2223|21|8080|5000|3306)' || echo "Ningún puerto activo"
