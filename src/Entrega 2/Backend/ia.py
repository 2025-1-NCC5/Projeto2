import psycopg2
import pandas as pd
from google.colab import userdata
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

from IPython.display import display
import ipywidgets as widgets

from sklearn.preprocessing import LabelEncoder

db_config = {
    "host": "db-vuca.ca7iq48cqq2l.us-east-1.rds.amazonaws.com",
    "port": "5432",
    "dbname": "db-vuca",
    "user": "postgres",
    "password": userdata.get('naoeasenha')
}

conn = psycopg2.connect(**db_config)

view_name = "treino_ia"
query = f"SELECT * FROM {view_name};"
df = pd.read_sql(query, conn)
conn.close()

df['tempo_estim_minutos'] = df['tempo_estim_segundos'] / 60

le_tipo_pedido = LabelEncoder()
df['ProductID_encoded'] = le_tipo_pedido.fit_transform(df['ProductID'])
df.drop('ProductID', axis=1, inplace=True)

df['metros_por_minuto'] = df['distancia_m'] / df['tempo_estim_minutos']

df = df[df['ano'] == 2022]
modelo = RandomForestRegressor(n_estimators=100)

x = df[['distancia_m', 'tempo_estim_minutos', 'ProductID_encoded', 'dia', 'mes', 'e_fim_de_semana', 'Fee']]
y = df['Price']
treino_x, teste_x, treino_y, teste_y = train_test_split(x, y, test_size=0.3, random_state=42)
modelo.fit(treino_x, treino_y)
acuracia = modelo.score(teste_x, teste_y) * 100
print(f"Acuracia: {acuracia:.2f}%")
predicao = modelo.predict(teste_x)
mae = mean_absolute_error(teste_y, predicao)
mse = mean_squared_error(teste_y, predicao)
rmse = np.sqrt(mse)
r2 = r2_score(teste_y, predicao)
print(f"MAE: {mae:.2f}")
print(f"MSE: {mse:.2f}")
print(f"RMSE: {rmse:.2f}")
print(f"R²: {r2:.2f}")

def formulario():
  distancia = widgets.FloatText(description='Distância:')
  tempo = widgets.FloatText(description='Tempo:')
  categoria = widgets.FloatText(description='Categoria da Corrida:')
  dia = widgets.Dropdown(options=range(1, 32), description='Dia:')
  mes = widgets.Dropdown(options=range(1, 13), description='Mês:')
  fim_de_semana = widgets.Checkbox(description='Fim de Semana:')
  fee = widgets.FloatText(description='Fee:')

  botao = widgets.Button(description='Calcular Corrida')

  def ao_clicar(b):
    entrada = pd.DataFrame([{
        'distancia_m': distancia.value,
        'tempo_estim_minutos': tempo.value,
        'ProductID_encoded': categoria.value,
        'dia': dia.value - 1,
        'mes': mes.value,
        'e_fim_de_semana': fim_de_semana.value,
        'Fee': fee.value
    }])
    pred = modelo.predict(entrada)[0]

    print("\n **** RESULTADO DA PREDIÇÃO ****")
    print(f" -> Preço corrida: {pred}")

  botao.on_click(ao_clicar)
  display(distancia, tempo, categoria, dia, mes, fim_de_semana, fee, botao)

formulario()
