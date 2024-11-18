#!/bin/bash

# Obtener el directorio del script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$DIR/app_pids.txt"

# Función para iniciar las aplicaciones
start_apps() {
    echo "Iniciando aplicaciones..."
    python3 "$DIR/sensor.py" &
    SENSOR_PID=$!
    python3 "$DIR/app.py" &
    APPFLASK_PID=$!

    # Guardar los PIDs en un archivo
    echo "$SENSOR_PID" > "$PID_FILE"
    echo "$APPFLASK_PID" >> "$PID_FILE"
    echo "Aplicaciones iniciadas con PID: Sensor=$SENSOR_PID, app=$APPFLASK_PID"
}

# Función para detener las aplicaciones
stop_apps() {
    if [[ -f "$PID_FILE" ]]; then
        echo "Deteniendo aplicaciones..."
        while IFS= read -r pid; do
            kill "$pid" 2>/dev/null && echo "Proceso $pid detenido."
        done < "$PID_FILE"
        rm -f "$PID_FILE"
        echo "Aplicaciones detenidas."
    else
        echo "No se encontraron aplicaciones en ejecución."
    fi
}

# Función para borrar la base de datos
delete_db() {
    read -p "¿Estás seguro de que deseas borrar datos_arduino.db? (s/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        rm -f "$DIR/datos_arduino.db"
        echo "Base de datos borrada."
    else
        echo "Operación cancelada."
    fi
}

# Función para ejecutar el script verbd.py
run_verd() {
    echo "Ejecutando verbd.py..."
    python3 "$DIR/verbd.py"
}

# Manejo de señales para detener aplicaciones al recibir SIGTERM o SIGINT
trap stop_apps SIGTERM SIGINT

# Comprobar argumentos
case "$1" in
    start)
        start_apps
        ;;
    stop)
        stop_apps
        ;;
    del-db)
        delete_db
        ;;
    ver-db)
        run_verd
        ;;
    *)
        echo "Uso: $0 {start|stop|del-db|ver-db}"
        ;;
esac
