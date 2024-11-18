#!/bin/bash

# Directorio para guardar los logs
LOG_DIR="benchmark_logs"
mkdir -p $LOG_DIR

# IPERF3 - Medición de rendimiento de red
IPERF_SERVER=192.168.0.10
echo "Iniciando prueba de red con iperf3..." | tee -a $LOG_DIR/iperf3_log.txt
iperf3 -c $IPERF_SERVER | tee -a $LOG_DIR/iperf3_log.txt
echo "Prueba de red finalizada." | tee -a $LOG_DIR/iperf3_log.txt

# HDPARM - Medición de velocidad de lectura del disco
echo "Iniciando prueba de disco con hdparm..." | tee -a $LOG_DIR/hdparm_log.txt
for i in {1..10}; do
    echo "Prueba $i:" | tee -a $LOG_DIR/hdparm_log.txt
    sudo hdparm -Tt /dev/mmcblk0 | tee -a $LOG_DIR/hdparm_log.txt
done
echo "Prueba de disco finalizada." | tee -a $LOG_DIR/hdparm_log.txt

# DSTAT - Monitoreo general del sistema
echo "Iniciando monitoreo general del sistema con dstat..." 
dstat -cdmn 10 10 > $LOG_DIR/dstat_log.txt

echo "Monitoreo de sistema finalizado."

# SYSSTAT - Medición de rendimiento detallado del sistema
echo "Iniciando recolección de métricas de sysstat..."
sar -o 1 10 >$LOG_DIR/sysstat_log.txt
echo "Recolección de métricas de sysstat finalizada."

# IOSTAT - Medición de rendimiento de I/O del disco
echo "Iniciando monitoreo de I/O de disco con iostat..." | tee -a $LOG_DIR/iostat_log.txt
iostat -dx 5 3 | tee -a $LOG_DIR/iostat_log.txt
echo "Monitoreo de I/O de disco finalizado." | tee -a $LOG_DIR/iostat_log.txt

# Resumen finalizado
echo "Todas las pruebas han sido completadas. Logs guardados en el directorio $LOG_DIR"
