const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'http://database-vuca.cbk8u24oqs2b.sa-east-1.rds.amazonaws.com',
  database: 'database-vuca',
  password: 's254mCW2JkWRhsV',
  port: 5432,
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
