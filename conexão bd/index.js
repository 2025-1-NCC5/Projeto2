const express = require('express');
const cors = require('cors');
const pool = require('./bd');
const nodemailer = require('nodemailer');
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
    res.status(200).json({ mensagem: "Consulta feita com sucesso!", usuario: result.rows })
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
      res.status(200).json({ mensagem: "Usuário encontrado com sucesso!", usuario: result.rows[0] });
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
      res.status(409).json({ sucesso: true, mensagem: "E-mail já cadastrado!", usuario: result.rows[0] });
    } else {
      try {
        await pool.query(
          "INSERT INTO usuarios (nome, telefone, email, senha, data_de_nasc) VALUES ($1, $2, $3, $4, $5) RETURNING *",
          [nome, telefone, email, senha, data_de_nasc]
        );
        res.status(201).json({ sucesso: true, usuario: result.rows[0] });
      } catch (error) {
        console.error("Erro ao cadastrar usuário:", error);
        res.status(500).send({ sucesso: false, mensagem: "Erro no servidor." });
      }
    }
  } catch {
    res.status(500).send("Erro no servidor.");
  }
});

app.post('/login', async (req, res) => {
  const { email, senha } = req.body;
  try {
    const result = await pool.query(
      'SELECT * FROM usuarios WHERE email = $1 AND senha = $2',
      [email, senha]
    );
    if (result.rows.length > 0) {
      res.status(200).json({ sucesso: true, mensagem: "Login realizado com sucesso!", usuario: result.rows[0] });
    } else {
      res.status(401).json({ sucesso: false, mensagem: "Email ou senha inválidos." });
    }
  } catch (error) {
    console.error("Erro ao fazer login:", error);
    res.status(500).send("Erro no servidor.");
  }
});

app.put('/alterarSenha', async (req, res) => {
  const { email, senhaAntiga, senhaNova } = req.body;
  try {
    const result = await pool.query(
      'SELECT * FROM usuarios WHERE email = $1 AND senha = $2',
      [email, senhaAntiga]
    );
    if (result.rows.length > 0) {
      try {
        await pool.query(
          'UPDATE usuarios SET senha = $1, token = NULL WHERE email = $2',
          [senhaNova, email]
        );
        res.status(201).json(result.rows[0]);
      } catch {
        console.error("Erro ao alterar senha:", error);
        res.status(500).send("Erro no servidor.");
      }
    } else {
      res.status(401).json({ mensagem: "Email ou token inválidos." });
    }
  } catch (error) {
    console.error("Erro ao procurar usuário:", error);
    res.status(500).send("Erro no servidor.");
  }
});

app.put('/alterarUsuario', async (req, res) => {
  const { email, senha, emailNovo } = req.body;
  try {
    const result = await pool.query(
      'SELECT * FROM usuarios WHERE email = $1 AND senha = $2',
      [email, senha]
    );
    if (result.rows.length > 0) {
      try {
        await pool.query(
          'UPDATE usuarios SET email = $1 WHERE email = $2',
          [emailNovo, email]
        );
        res.status(201).json(result.rows[0]);
      } catch {
        console.error("Erro ao alterar usuário:", error);
        res.status(500).send("Erro no servidor.");
      }
    } else {
      res.status(401).json({ mensagem: "Email ou senha inválidos." });
    }
  } catch (error) {
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
    if (result.rows.length > 0) {
      try {
        await pool.query(
          'DELETE FROM usuarios WHERE email = $1',
          [email]);
        res.status(200).json({ sucesso: true, usuario: result.rows[0] });
      } catch {
        console.error("Erro ao excluir usuário:", error);
        res.status(500).json({ sucesso: false, mensagem: "Erro ao excluir usuário." });
      }
    } else {
      res.status(401).json({ sucesso: false, mensagem: "Email ou senha inválidos." });
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
    const result = await pool.query('SELECT * FROM usuarios WHERE email = $1', [email]);
    if (result.rows.length == 0) {
      return res.status(404).json({ message: 'E-mail não encontrado.' });
    } else {
      try {
        var transporter = nodemailer.createTransport({
          host: "smtp.gmail.com",
          port: 465,
          secure: true,
          auth: {
            user: "startup.vuca@gmail.com",
            pass: "bweyzskghfgcccal"
          }
        });

        transporter.sendMail({
          from: 'VUCA <startup.vuca@gmail.com>',
          to: email,
          subject: 'Recuperação de Senha',
          html: '<h1>Link para recuperação de senha: </h1> <link>https://lambent-pavlova-f28d99.netlify.app</link>',
          text: 'Link para recuperação de senha: https://lambent-pavlova-f28d99.netlify.app',
        });
      } catch (error) {
        console.error('Erro ao enviar email de recuperação:', error);
        res.status(500).json({ message: 'Erro interno do servidor.' });
      }

    }
  } catch (error) {
    console.error('Erro ao buscar email:', error);
    res.status(500).json({ message: 'Erro interno do servidor.' });
  }
});

app.post('/modificaçãoRecuperaçãoSenha', async (req, res) => {
  const { email, senha } = req.body;

  try {
    const [rows] = await pool.query('SELECT * FROM usuarios WHERE email = $1', [email]);
    if (result.rows.length > 0) {
      try {
        await pool.query(
          'UPDATE usuarios SET senha = $1 WHERE email = $2',
          [senha, email]
        );
        res.status(201).json(result.rows[0]);
      } catch {
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

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
