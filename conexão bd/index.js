const express = require('express');
const cors = require('cors');
const pool = require('./bd');
const app = express();
const AWS = require('aws-sdk');
require('dotenv').config();

app.use(cors());
app.use(express.json());

const ses = new AWS.SES({
  region: process.env.AWS_REGION,
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
});

app.get('/acessarBancoDados', async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM ride_v2 limit 10'
      
    );
    res.status(200).json({mensagem: "Consulta feita com sucesso!", usuario: result.rows})
  } catch (error) {
    console.error("Erro ao buscar usuário:", error);
    res.status(500).send("Erro no servidor.");
  }
});

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
      'SELECT * FROM usuarios WHERE email = $1',
      [email]
    );
    if (result.rows.length > 0) {
      res.status(200).json({sucesso: true, mensagem: "E-mail já cadastrado!", usuario: result.rows[0]});
    } else {
      try{
        await pool.query(
          "INSERT INTO usuarios (nome, telefone, email, senha, data_de_nasc) VALUES ($1, $2, $3, $4, $5) RETURNING *",
          [nome, telefone, email, senha, data_de_nasc]
        );
        res.status(201).json(result.rows[0]);
      }catch (error){
        console.error("Erro ao cadastrar usuário:", error);
        res.status(500).send({sucesso: false, mensagem: "Erro no servidor."});
      }
    }
  } catch{
    res.status(500).send("Erro no servidor.");
  }
});

app.post('/login', async (req, res) => {
  const {email, senha} = req.body;
  try {
    const result = await pool.query(
      'SELECT * FROM usuarios WHERE email = $1 AND senha = $2',
      [email, senha]
    );
    if (result.rows.length > 0) {
      res.status(200).json({ sucesso: true,  mensagem: "Login realizado com sucesso!", usuario: result.rows[0]});
    } else {
      res.status(401).json({ sucesso: false, mensagem: "Email ou senha inválidos." });
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
          'UPDATE usuarios SET senha = $1, token = NULL WHERE email = $2',
          [senhaNova, email]
          );
          res.status(201).json(result.rows[0]); 
      }catch{
        console.error("Erro ao alterar senha:", error);
        res.status(500).send("Erro no servidor.");
      }
    }else{
      res.status(401).json({ mensagem: "Email ou token inválidos." });
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

app.post('/recover-password', async (req, res) => {
  const { email } = req.body;

  try {
    const [rows] = await pool.query('SELECT * FROM usuarios WHERE email = $1', [email]);
    if (rows.length === 0) {
      return res.status(404).json({ message: 'E-mail não encontrado.' });
    }
    const user = rows[0];
    const resetToken = generateResetToken();

    const emailParams = {
      Source: process.env.SES_FROM_EMAIL,
      Destination: {
        ToAddresses: [user.email],
      },
      Message: {
        Subject: {
          Data: 'Recuperação de Senha',
        },
        Body: {
          Text: {
            Data: `Clique no link para redefinir sua senha: ${process.env.APP_URL}/reset-password?token=${resetToken}`,
          },
        },
      },
    };

    await ses.sendEmail(emailParams).promise();
    res.status(200).json({ message: 'E-mail de recuperação enviado com sucesso.' });
  } catch (error) {
    console.error('Erro ao processar a solicitação:', error);
    res.status(500).json({ message: 'Erro interno do servidor.' });
  }
});

app.post('/modificaçãoRecuperaçãoSenha', async (req, res) => {
  const { email, token, senha } = req.body;

  try {
    const [rows] = await pool.query('SELECT * FROM usuarios WHERE email = $1 AND tokenSenha = $2', [email, token]);
    if (result.rows.length > 0) {
      try{
        await pool.query(
          'UPDATE usuarios SET senha = $1 WHERE email = $2',
          [senha, email]
          );
          res.status(201).json(result.rows[0]); 
      }catch{
        console.error("Erro ao alterar senha:", error);
        res.status(500).send("Erro no servidor.");
      }
    } else {
      res.status(401).json({ mensagem: "Email ou token inválidos." });
    }
  } catch (error) {
    console.error("Erro ao fazer login:", error);
    res.status(500).send("Erro no servidor.");
  }
});

function generateResetToken() {
  return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
}

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
