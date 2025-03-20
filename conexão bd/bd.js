require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
  user: process.env.user,
  host: process.env.host,
  database: process.env.database,
  password: process.env.password,
  port: process.env.port,
  ssl: {
    rejectUnauthorized: false, // Necessário para conexão segura com o RDS
  },
});

// Função para testar a conexão
const testConnection = async () => {
  try {
    const client = await pool.connect();
    console.log("Conexão bem-sucedida com o banco de dados!");
    client.release();
  } catch (error) {
    console.error("Erro ao conectar com o banco de dados:", error);
  }
};

// Testar conexão ao iniciar o backend
testConnection();

module.exports = pool;
