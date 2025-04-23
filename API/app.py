import psycopg2
import pandas as pd
from dotenv import load_dotenv
import os
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score

from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix
from sklearn.metrics import classification_report
from sklearn.metrics import mean_absolute_error
from sklearn.metrics import mean_squared_error
from sklearn.metrics import r2_score
from sklearn.metrics import accuracy_score

from sklearn.linear_model import LinearRegression
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.neighbors import KNeighborsRegressor
from sklearn.ensemble import GradientBoostingRegressor

from sklearn.preprocessing import LabelEncoder

import pandas as pd
from flask_ngrok import run_with_ngrok
from flask import (
    request, jsonify, Flask
)
import random as rk

from sys import dont_write_bytecode
from flask import Flask
from pyngrok import ngrok
import threading
import requests
from datetime import datetime
import json

secret_key = os.getenv('JWT_SECRET')

db_config = {
    "host": "db-vuca.ca7iq48cqq2l.us-east-1.rds.amazonaws.com",
    "port": "5432",
    "dbname": "db-vuca",
    "user": "postgres",
    "password": secret_key
}

conn = psycopg2.connect(**db_config)
print("Conectado ao banco!")

view_name = "treino_ia"

query = f"SELECT * FROM {view_name};"

df = pd.read_sql(query, conn)
conn.close()

categoriasUber = [1, 2, 4, 5, 8, 9, 10]
df = df[df['ano'] == 2022]
df = df[df['nome_empresa'] == "Uber"]
df = df[df["CategoryID"].isin(categoriasUber)]

df['tempo_estim_minutos'] = df['tempo_estim_segundos'] / 60

encoder = LabelEncoder()
df['ProductID_encoded'] = encoder.fit_transform(df['ProductID'])
df.drop('ProductID', axis=1, inplace=True)

df['metros_por_minuto'] = df['distancia_m'] / df['tempo_estim_minutos']

modelo = RandomForestRegressor(n_estimators=100)
x = df[['distancia_m', 'tempo_estim_minutos', 'ProductID_encoded', 'dia', 'mes', 'e_fim_de_semana']]
y = df['Price']
treino_x, teste_x, treino_y, teste_y = train_test_split(x, y, test_size=0.3, random_state=42)
modelo.fit(treino_x, treino_y)

app = Flask(__name__)

@app.route("/calcularCorrida", methods=['GET'])
def get_precoCorrida():
    agora = datetime.now()
    origem = request.args.get('origem')
    destino = request.args.get('destino')

    api_key = "AIzaSyCDmnx17lJCCO7GMJEIlqeBlRjnHxfI8b8"
    rota = f"https://maps.googleapis.com/maps/api/distancematrix/json?destinations={destino}&origins={origem}&key={api_key}"

    responseRota = requests.get(rota)
    jsonRota = responseRota.json()

    distancia = jsonRota['rows'][0]['elements'][0]['distance']['value']

    duracao_segundos = jsonRota['rows'][0]['elements'][0]['duration']['value']
    duracao_minutos = duracao_segundos // 60

    codigos_categorias = df['ProductID_encoded'].unique().tolist()
    precos_por_categoria = {}

    for codigo in codigos_categorias:
        entrada = pd.DataFrame([{
            'distancia_m': distancia,
            'tempo_estim_minutos': duracao_minutos,
            'ProductID_encoded': codigo,
            'dia': agora.day - 1,
            'mes': agora.month,
            'e_fim_de_semana': agora.weekday() >= 5
        }])
        pred = modelo.predict(entrada)[0]
        nome_categoria = encoder.inverse_transform([codigo])[0]
        precos_por_categoria[nome_categoria] = round(pred, 2)


    precos_ordenados = dict(sorted(precos_por_categoria.items(), key=lambda item: item[1]))
    json_precos = json.dumps(precos_ordenados, ensure_ascii=False, indent=2)
    return json_precos

if __name__ == '__main__':
    app.run(debug=True)