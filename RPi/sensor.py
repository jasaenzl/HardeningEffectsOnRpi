import serial
import sqlite3
import time
import select

# Configura el puerto serial para el Arduino
arduino = serial.Serial('/dev/ttyACM0', 9600)  # Cambia '/dev/ttyACM0' según corresponda

# Conexión a la base de datos SQLite
conn = sqlite3.connect('datos_arduino.db')
cursor = conn.cursor()

# Crear la tabla si no existe
cursor.execute('''
CREATE TABLE IF NOT EXISTS datos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    valor REAL
)
''')

# Bucle principal
try:
    while True:
        # Usa select para esperar datos de entrada sin consumir procesamiento
        readable, _, _ = select.select([arduino], [], [], 1)  # Timeout de 1 segundo
        if readable:
            # Lee los datos cuando estén disponibles
            data = arduino.read()  # Lee un byte
            if data:
                valor_adc = ord(data)  # Convierte el byte a un valor entero
            
                # Inserta el valor en la base de datos
                cursor.execute('INSERT INTO datos (valor) VALUES (?)', (valor_adc,))
                conn.commit()  # Guarda los cambios en la base de datos
                #print(f"Valor ADC: {valor_adc} guardado en la base de datos.")
except KeyboardInterrupt:
    print("Finalizando la lectura...")
finally:
    # Cerrar la conexión a la base de datos y el puerto serial
    conn.close()
    arduino.close()
