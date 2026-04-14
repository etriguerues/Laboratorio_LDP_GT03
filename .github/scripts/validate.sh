#!/bin/bash
export LANG=C.UTF-8

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' 

echo "--------------------------------------------------------"
echo "Validación Lab: Monitor de Red (Python)"
echo "--------------------------------------------------------"

FAILED=0
FILE_PY=$(find . -name "*.py" | head -n 1)
[ -z "$FILE_PY" ] && { echo -e "${RED}[ERROR] Sin archivo .py.${NC}"; exit 1; }
echo -e "Archivo detectado: ${YELLOW}$FILE_PY${NC}\n"

# --- PASO 1: FUNCION Y GUARDA ---
echo -e "${YELLOW}PASO 1: Verificando Función y Cláusula de Guarda...${NC}"
if grep -qE "def\s+analizar_paquete" "$FILE_PY" && grep -qE "if\s+.*==\s*[\"']Corrupto[\"']:" "$FILE_PY"; then echo -e "${GREEN}[OK] Función y cláusula de guarda listas.${NC}"; else echo -e "${RED}[ERROR] Error en def analizar_paquete o falta la guarda para 'Corrupto'.${NC}"; FAILED=1; fi

# --- PASO 2: PATTERN MATCHING ---
echo -e "\n${YELLOW}PASO 2: Verificando Pattern Matching...${NC}"
if grep -qE "match\s+" "$FILE_PY" && grep -qE "case\s+[\"']Video[\"']:" "$FILE_PY" && grep -qE "case\s+_:" "$FILE_PY"; then echo -e "${GREEN}[OK] Bloque match-case encontrado.${NC}"; else echo -e "${RED}[ERROR] Falla estructural en el match o en los cases solicitados.${NC}"; FAILED=1; fi

# --- PASO 3: CICLOS FOR Y WHILE ---
echo -e "\n${YELLOW}PASO 3: Verificando Ciclos (for y while)...${NC}"
if grep -qE "for\s+.*\s+in\s+trafico:" "$FILE_PY" && grep -qE "while\s+ancho_banda\s*>\s*0:" "$FILE_PY"; then echo -e "${GREEN}[OK] Iteraciones for y while detectadas.${NC}"; else echo -e "${RED}[ERROR] Faltan los ciclos sobre 'trafico' o el 'while ancho_banda > 0'.${NC}"; FAILED=1; fi

# --- PASO 4: CORTOCIRCUITO Y TERNARIO ---
echo -e "\n${YELLOW}PASO 4: Verificando Cortocircuito y Operador Ternario...${NC}"
if grep -qE "if\s+.*\s+and\s+red_activa:" "$FILE_PY"; then echo -e "${GREEN}[OK] Cortocircuito con 'and' verificado.${NC}"; else echo -e "${RED}[ERROR] Falta el cortocircuito evaluando 'red_activa'.${NC}"; FAILED=1; fi
if grep -qE "estado_red\s*=\s*[\"'].*[\"']\s+if\s+.*\s+else\s+[\"'].*[\"']" "$FILE_PY"; then echo -e "${GREEN}[OK] Ternario asignado a estado_red detectado.${NC}"; else echo -e "${RED}[ERROR] La variable estado_red no usa asignación ternaria.${NC}"; FAILED=1; fi

# --- PASO 5: COMPILACIÓN Y SINTAXIS ---
echo -e "\n${YELLOW}PASO 5: Verificando sintaxis de Python...${NC}"
if python3 -m py_compile "$FILE_PY" 2>/dev/null; then echo -e "${GREEN}[OK] Sintaxis correcta.${NC}"; else echo -e "${RED}[ERROR] Error de sintaxis.${NC}"; python3 -m py_compile "$FILE_PY"; FAILED=1; fi

[ $FAILED -eq 0 ] && { echo -e "\n${GREEN}✔ LABORATORIO 3 APROBADO${NC}"; exit 0; } || { echo -e "\n${RED}✘ LAB FALLIDO${NC}"; exit 1; }