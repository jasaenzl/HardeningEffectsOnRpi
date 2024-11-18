import sqlite3
from flask import Flask, render_template, jsonify, request

app = Flask(__name__)

def get_latest_data(limit=50):
    conn = sqlite3.connect('datos_arduino.db')
    c = conn.cursor()
    # Selecciona los últimos datos y ordena en orden ascendente para el gráfico
    c.execute('SELECT timestamp, valor FROM datos ORDER BY timestamp DESC LIMIT ?', (limit,))
    data = c.fetchall()[::-1]  # Invertir para obtener en orden cronológico
    conn.close()
    return data

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/data')
def data():
    data = get_latest_data()
    return jsonify(data)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
