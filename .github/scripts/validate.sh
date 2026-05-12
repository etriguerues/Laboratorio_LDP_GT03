#!/bin/bash
export LANG=C.UTF-8
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' 

echo "--------------------------------------------------------"
echo "Validación Lab 3: Sistema de Almacén"
echo "--------------------------------------------------------"

FAILED=0
FILE_PY=$(find . -name "*.py" | head -n 1)
[ -z "$FILE_PY" ] && { echo -e "${RED}[ERROR] Sin archivo .py.${NC}"; exit 1; }

echo -e "${YELLOW}PASO 1: Verificando Arreglo Decimal y Lista (.insert)...${NC}"
if grep -qE "array\.array\(\s*['\"]d['\"]" "$FILE_PY" && grep -qE "\.insert\(\s*1\s*," "$FILE_PY"; then echo -e "${GREEN}[OK] Array tipo 'd' e inserción en índice 1 correctos.${NC}"; else echo -e "${RED}[ERROR] Falta el array 'd' o el uso de .insert(1, ...).${NC}"; FAILED=1; fi

echo -e "\n${YELLOW}PASO 2: Verificando Matriz 3D y Árbol Binario...${NC}"
if grep -qE "\[0\]\[0\]\[1\]" "$FILE_PY" && grep -qE "class NodoRuta" "$FILE_PY" && grep -qE "\.rapida\s*=" "$FILE_PY"; then echo -e "${GREEN}[OK] Lectura de coordenadas 3D y árbol binario verificados.${NC}"; else echo -e "${RED}[ERROR] Falla en coordenadas [0][0][1], clase NodoRuta o asignación a .rapida.${NC}"; FAILED=1; fi

echo -e "\n${YELLOW}PASO 3: Verificando Serialización JSON...${NC}"
if grep -qE "json\.dumps\(" "$FILE_PY"; then echo -e "${GREEN}[OK] Datos empaquetados en JSON correctamente.${NC}"; else echo -e "${RED}[ERROR] No se usó json.dumps().${NC}"; FAILED=1; fi

if python3 -m py_compile "$FILE_PY" 2>/dev/null; then echo -e "\n${GREEN}[OK] Sintaxis exitosa.${NC}"; else echo -e "\n${RED}[ERROR] Falla sintáctica.${NC}"; FAILED=1; fi

[ $FAILED -eq 0 ] && { echo -e "\n${GREEN}✔ LABORATORIO 3 APROBADO${NC}"; exit 0; } || { echo -e "\n${RED}✘ LAB FALLIDO${NC}"; exit 1; }
