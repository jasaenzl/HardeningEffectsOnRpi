import sqlite3

# Conectar a la base de datos
conn = sqlite3.connect('datos_arduino.db')
c = conn.cursor()

# Seleccionar todos los datos de la tabla
c.execute('SELECT * FROM datos')
data = c.fetchall()

# Cerrar la conexión a la base de datos
conn.close()

# Imprimir los datos
for row in data:
    print(row)
