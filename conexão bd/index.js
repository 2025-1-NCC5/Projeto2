const express = require('express');
const pool = require('./bd');
const app = express();

app.use(express.json());

app.get('/listarUsuario', async (req, res) => {
  const { email } = req.body;
  try {
    const result = await pool.query(
      'SELECT * FROM usuarios WHERE email = $1',
      [email]
    );
    if (result.rows.length > 0) {
      res.status(200).json({ mensagem: "Usuário encontrado com sucesso!", usuario: result.rows[0]});
    } else {
      res.status(401).json({ mensagem: "Email ou senha inválidos." });
    }
  } catch (error) {
    console.error("Erro ao buscar usuário:", error);
    res.status(500).send("Erro no servidor.");
  }
});

app.post('/cadastrar', async (req, res) => {
  const { nome, telefone, email, senha, data_de_nasc } = req.body;
  try {
    const result = await pool.query(
      "INSERT INTO usuarios (nome, telefone, email, senha, data_de_nasc) VALUES ($1, $2, $3, $4, $5) RETURNING *",
      [nome, telefone, email, senha, data_de_nasc]
    );
    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error("Erro ao inserir usuário:", error);
    res.status(500).send("Erro no servidor.");
  }
});

app.get('/login', async (req, res) => {
  const {email, senha} = req.body;
  try {
    const result = await pool.query(
      'SELECT * FROM usuarios WHERE email = $1 AND senha = $2',
      [email, senha]
    );
    if (result.rows.length > 0) {
      res.status(200).json({ mensagem: "Login realizado com sucesso!", usuario: result.rows[0]});
    } else {
      res.status(401).json({ mensagem: "Email ou senha inválidos." });
    }
  } catch (error) {
    console.error("Erro ao fazer login:", error);
    res.status(500).send("Erro no servidor.");
  }
});

app.put('/alterarSenha', async (req, res) => {
  const {email, senhaAntiga, senhaNova} = req.body;
  try{
    const result = await pool.query(
      'SELECT * FROM usuarios WHERE email = $1 AND senha = $2',
      [email, senhaAntiga]
    );
    if (result.rows.length > 0) {
      try{
        await pool.query(
          'UPDATE usuarios SET senha = $1 WHERE email = $2',
          [senhaNova, email]
          );
          res.status(201).json(result.rows[0]); 
      }catch{
        console.error("Erro ao alterar senha:", error);
        res.status(500).send("Erro no servidor.");
      }
    }else{
      res.status(401).json({ mensagem: "Email ou senha inválidos." });
    }
  }catch(error){
    console.error("Erro ao procurar usuário:", error);
    res.status(500).send("Erro no servidor.");
  }
});

app.put('/alterarUsuario', async (req, res) => {
  const {email, senha, emailNovo} = req.body;
  try{
    const result = await pool.query(
      'SELECT * FROM usuarios WHERE email = $1 AND senha = $2',
      [email, senha]
    );
    if (result.rows.length > 0) {
      try{
        await pool.query(
          'UPDATE usuarios SET email = $1 WHERE email = $2',
          [emailNovo, email]
          );
          res.status(201).json(result.rows[0]); 
      }catch{
        console.error("Erro ao alterar usuário:", error);
        res.status(500).send("Erro no servidor.");
      }
    }else{
      res.status(401).json({ mensagem: "Email ou senha inválidos." });
    }
  }catch(error){
    console.error("Erro ao procurar usuário:", error);
    res.status(500).send("Erro no servidor.");
  }
});

app.post('/deletarUsuario', async (req, res) => {
  const { email, senha } = req.body;
  try {
    const result = await pool.query(
      'SELECT * FROM usuarios WHERE email = $1 AND senha = $2',
      [email, senha]
    );
    if(result.rows.length > 0){
      try{
        await pool.query(
          'DELETE FROM usuarios WHERE email = $1',
          [email]);
          res.status(201).json(result.rows[0]); 
      }catch{
        console.error("Erro ao alterar senha:", error);
        res.status(500).send("Erro no servidor.");
      }
    }else{
      res.status(401).json({ mensagem: "Email ou senha inválidos." });
    }
  } catch (error) {
    console.error("Erro ao deletar usuário:", error);
    res.status(500).send("Erro no servidor.");
  }
});

app.post('/calcularCorrida', async (req, res) => {
  const { origem, destino } = req.body;
  try {
    
  } catch (error) {
    console.error("Erro ao simular corrida:", error);
    res.status(500).send("Erro no servidor.");
  }
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
