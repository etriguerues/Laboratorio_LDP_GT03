#!/bin/bash
export LANG=C.UTF-8

# Colores para la salida en consola
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0;0m' # Sin color

echo "--------------------------------------------------------"
echo "Iniciando validación: Estación Climática (Ciclo Para)"
echo "--------------------------------------------------------"

# Variable de control de errores
FAILED=0

# Buscar el archivo .psc
FILE_PSC=$(find . -name "*.psc" | head -n 1)

if [ -z "$FILE_PSC" ]; then
    echo -e "${RED}[ERROR] No se encontró ningún archivo .psc (PSeInt).${NC}"
    exit 1
fi

echo -e "Archivo detectado: ${YELLOW}$FILE_PSC${NC}"

# --- PASO 1: VERIFICAR FUNCIÓN OBLIGATORIA ---
echo -e "\n${YELLOW}PASO 1: Verificando Función ClasificarTemperatura...${NC}"

# Validar definición de la función y retorno de cadena (Caracter)
if grep -qi "Funcion.*ClasificarTemperatura" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Función 'ClasificarTemperatura' detectada.${NC}"
else
    echo -e "${RED}[ERROR] No se encontró la función 'ClasificarTemperatura'.${NC}"
    FAILED=1
fi

if grep -qi "Como Caracter" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Definición de retorno 'Caracter' encontrada.${NC}"
else
    echo -e "${RED}[ERROR] La función debe retornar un tipo 'Caracter' (texto).${NC}"
    FAILED=1
fi

# --- PASO 2: VERIFICAR LÓGICA DE TEMPERATURA (SI-ENTONCES) ---
echo -e "\n${YELLOW}PASO 2: Verificando Lógica Interna de la Función...${NC}"

# Validar el umbral de 35 grados y el mensaje de alerta
if grep -q "35" "$FILE_PSC" && grep -qi "Calor Extremo" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Lógica de alerta por Calor Extremo (>= 35) detectada.${NC}"
else
    echo -e "${RED}[ERROR] No se encontró la validación de 35 grados o el mensaje de 'Calor Extremo'.${NC}"
    FAILED=1
fi

# --- PASO 3: VERIFICAR CICLO PARA ---
echo -e "\n${YELLOW}PASO 3: Verificando Estructura de Iteración (Para)...${NC}"

# Validar el uso del ciclo Para desde 1 hasta cantidad
if grep -qiE "Para.*<-.*1.*Hasta.*cantidad" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Ciclo 'Para' configurado correctamente (1 hasta cantidad).${NC}"
else
    echo -e "${RED}[ERROR] No se encontró un ciclo 'Para' que itere desde 1 hasta 'cantidad'.${NC}"
    FAILED=1
fi

# --- PASO 4: VARIABLES Y TIPOS ---
echo -e "\n${YELLOW}PASO 4: Verificando Variables Principales...${NC}"

# Validar cantidad como Entero y temp_actual como Real
if grep -qiE "Definir.*cantidad.*Como.*Entero" "$FILE_PSC" && grep -qiE "Definir.*temp_actual.*Como.*Real" "$FILE_PSC"; then
    echo -e "${GREEN}[OK] Variables 'cantidad' (Entero) y 'temp_actual' (Real) definidas.${NC}"
else
    echo -e "${RED}[ERROR] Error en la definición de tipos: 'cantidad' debe ser Entero y 'temp_actual' Real.${NC}"
    FAILED=1
fi

# --- RESULTADO FINAL ---
echo -e "\n--------------------------------------------------------"
if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✔ LABORATORIO: ESTACIÓN CLIMÁTICA APROBADO${NC}"
    exit 0
else
    echo -e "${RED}✘ EL ALGORITMO NO CUMPLE CON LOS REQUISITOS${NC}"
    exit 1
fi
