#!/bin/bash
export LANG=C.UTF-8

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' 

echo "--------------------------------------------------------"
echo "Validación Lab 3: Carrito E-commerce (Python)"
echo "--------------------------------------------------------"

FAILED=0
FILE_PY=$(find . -name "*.py" | head -n 1)
[ -z "$FILE_PY" ] && { echo -e "${RED}[ERROR] Sin archivo .py.${NC}"; exit 1; }
echo -e "Archivo detectado: ${YELLOW}$FILE_PY${NC}\n"

# --- PASO 1: CONSTANTES ---
echo -e "${YELLOW}PASO 1: Verificando Clean Code...${NC}"
if grep -qE "DESCUENTO_VIP\s*=\s*0\.20" "$FILE_PY"; then echo -e "${GREEN}[OK] Constante de descuento lista.${NC}"; else echo -e "${RED}[ERROR] Falta DESCUENTO_VIP = 0.20.${NC}"; FAILED=1; fi

# --- PASO 2: MUTABILIDAD ---
echo -e "\n${YELLOW}PASO 2: Verificando Copias Seguras...${NC}"
if grep -qE "carrito_simulado\s*=\s*carrito_actual\.copy\(\)" "$FILE_PY"; then echo -e "${GREEN}[OK] El carrito fue copiado con .copy().${NC}"; else echo -e "${RED}[ERROR] No se usó carrito_actual.copy().${NC}"; FAILED=1; fi

# --- PASO 3: LÓGICA Y CASTING ---
echo -e "\n${YELLOW}PASO 3: Verificando Lógica y Casting...${NC}"
if grep -qE "def\s+procesar_precio" "$FILE_PY" && grep -qE "float\s*\(" "$FILE_PY"; then echo -e "${GREEN}[OK] Función de precio y casting float detectados.${NC}"; else echo -e "${RED}[ERROR] Error en procesar_precio o falta float().${NC}"; FAILED=1; fi

# --- PASO 4: GARBAGE COLLECTOR ---
echo -e "\n${YELLOW}PASO 4: Verificando Garbage Collector...${NC}"
if grep -qE "carrito_actual\s*=\s*None" "$FILE_PY" && grep -qE "carrito_simulado\s*=\s*None" "$FILE_PY"; then echo -e "${GREEN}[OK] Ambas listas fueron destruidas.${NC}"; else echo -e "${RED}[ERROR] Faltan los asignamientos a None al final.${NC}"; FAILED=1; fi

# --- PASO 5: COMPILACIÓN Y SINTAXIS ---
echo -e "\n${YELLOW}PASO 5: Verificando sintaxis de Python...${NC}"
if python3 -m py_compile "$FILE_PY" 2>/dev/null; then 
    echo -e "${GREEN}[OK] Sintaxis correcta.${NC}"
else 
    echo -e "${RED}[ERROR] Error de sintaxis en Python.${NC}"
    python3 -m py_compile "$FILE_PY"
    FAILED=1
fi

[ $FAILED -eq 0 ] && { echo -e "\n${GREEN}✔ LABORATORIO 3 APROBADO${NC}"; exit 0; } || { echo -e "\n${RED}✘ LAB FALLIDO${NC}"; exit 1; }