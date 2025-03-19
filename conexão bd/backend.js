const express = require('express');
const pool = require('./db');
const app = express();

app.use(express.json());

app.post('/cadastrar', async (req, res) => {
  const { nome, telefone, email, senha, dataNasc } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO usuarios (nome, telefone, email, senha, dataNasc) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [nome, telefone, email, senha, dataNasc]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error("Erro ao inserir usuário:", error);
    res.status(500).send("Erro no servidor.");
  }
});

app.post('/login', async (req, res) => {
  const { nome, telefone, email, senha, dataNasc } = req.body;
  try {
    const result = await pool.query(
      'INSERT INTO usuarios (nome, telefone, email, senha, dataNasc) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [nome, telefone, email, senha, dataNasc]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error("Erro ao inserir usuário:", error);
    res.status(500).send("Erro no servidor.");
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
