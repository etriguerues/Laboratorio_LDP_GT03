#!/bin/bash
export LANG=C.UTF-8

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' 

echo "--------------------------------------------------------"
echo "Validación Lab: Motor XP (Python)"
echo "--------------------------------------------------------"

FAILED=0
FILE_PY=$(find . -name "*.py" | head -n 1)
[ -z "$FILE_PY" ] && { echo -e "${RED}[ERROR] Sin archivo .py.${NC}"; exit 1; }
echo -e "Archivo detectado: ${YELLOW}$FILE_PY${NC}\n"

# --- PASO 1: VARIABLES GLOBALES Y SRP ---
echo -e "${YELLOW}PASO 1: Verificando variables globales y función SRP...${NC}"
if grep -qE "historial_xp\s*=\s*\[\]" "$FILE_PY" && grep -qE "def\s+multiplicador_xp" "$FILE_PY"; then echo -e "${GREEN}[OK] Archivo inicializado con variables globales y la función multiplicador.${NC}"; else echo -e "${RED}[ERROR] Error en 'historial_xp' o falta 'multiplicador_xp'.${NC}"; FAILED=1; fi

# --- PASO 2: FUNCIONES ANIDADAS Y RECURSIVIDAD ---
echo -e "\n${YELLOW}PASO 2: Verificando Función Anidada, Caso Base y Recursividad...${NC}"
if grep -qE "def\s+jugar_niveles" "$FILE_PY" && grep -qE "def\s+superar_nivel" "$FILE_PY"; then echo -e "${GREEN}[OK] Estructura de contenedor y anidada validadas.${NC}"; else echo -e "${RED}[ERROR] Funciones 'jugar_niveles' o 'superar_nivel' no declaradas correctamente.${NC}"; FAILED=1; fi

if grep -qE "if\s+.*==\s*0:" "$FILE_PY" && grep -qE "return" "$FILE_PY" && grep -qE "superar_nivel\(.*\)" "$FILE_PY"; then echo -e "${GREEN}[OK] El stack recursivo es detenido correctamente con caso base.${NC}"; else echo -e "${RED}[ERROR] Falta el caso base '0' para detener la ejecución recursiva o su llamada.${NC}"; FAILED=1; fi

# --- PASO 3: TRAMPA DE REASIGNACIÓN (VALOR VS REFERENCIA) ---
echo -e "\n${YELLOW}PASO 3: Verificando Paso por Referencia y Trampa de Reasignación...${NC}"
if grep -qE "\.append\(" "$FILE_PY"; then echo -e "${GREEN}[OK] Se respetó el paso por referencia usando .append().${NC}"; else echo -e "${RED}[ERROR] La lista historial_xp no se modificó con .append().${NC}"; FAILED=1; fi
if grep -qE "def\s+promover_jugador" "$FILE_PY" && grep -qE "=\s*[\"']Experto[\"']" "$FILE_PY"; then echo -e "${GREEN}[OK] Función de Scope local (Experto) comprobada.${NC}"; else echo -e "${RED}[ERROR] No se programó correctamente la reasignación en 'promover_jugador'.${NC}"; FAILED=1; fi

# --- PASO 4: COMPILACIÓN ---
echo -e "\n${YELLOW}PASO 4: Verificando sintaxis...${NC}"
if python3 -m py_compile "$FILE_PY" 2>/dev/null; then echo -e "${GREEN}[OK] Compilación exitosa.${NC}"; else echo -e "${RED}[ERROR] Falla de sintaxis detectada.${NC}"; FAILED=1; fi

[ $FAILED -eq 0 ] && { echo -e "\n${GREEN}✔ LABORATORIO 3 APROBADO${NC}"; exit 0; } || { echo -e "\n${RED}✘ LAB FALLIDO${NC}"; exit 1; }