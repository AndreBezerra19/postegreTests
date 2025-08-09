# 🔧 Guia: Como Configurar a Conexão PostgreSQL no pgAdmin

Se você não está conseguindo ver o database e as tabelas no pgAdmin, siga este guia passo a passo:

## 📋 Passo a Passo

### 1. Acesse o pgAdmin
- Abra seu navegador
- Vá para: **http://localhost:8081**
- Faça login com:
  - **Email:** admin@test.com
  - **Senha:** admin

### 2. Adicione o Servidor PostgreSQL

#### 2.1 Clique em "Add New Server"
- No painel esquerdo, clique com o botão direito em "Servers"
- Selecione "Register" → "Server..."

#### 2.2 Aba "General"
- **Name:** `PostgreSQL Local` (ou qualquer nome de sua preferência)
- **Server Group:** Deixe como "Servers"
- **Comments:** `Servidor PostgreSQL para testes` (opcional)

#### 2.3 Aba "Connection"
- **Host name/address:** `postgres` ⚠️ **IMPORTANTE: Use "postgres", não "localhost"**
- **Port:** `5432`
- **Maintenance database:** `testdb`
- **Username:** `testuser`
- **Password:** `testpass`
- **Save password:** ✅ Marque esta opção

#### 2.4 Clique em "Save"

### 3. Navegue pelas Tabelas

Após conectar, você verá a estrutura:
```
Servers
└── PostgreSQL Local
    └── Databases
        └── testdb
            └── Schemas
                └── public
                    └── Tables
                        ├── usuarios
                        ├── produtos
                        └── pedidos
```

### 4. Visualize os Dados

#### Para ver os dados de uma tabela:
1. Clique com o botão direito na tabela (ex: "usuarios")
2. Selecione "View/Edit Data" → "All Rows"

#### Para executar consultas SQL:
1. Clique com o botão direito no database "testdb"
2. Selecione "Query Tool"
3. Digite suas consultas SQL

## 🔍 Consultas de Exemplo

Teste estas consultas no Query Tool:

```sql
-- Ver todos os usuários
SELECT * FROM usuarios;

-- Ver todos os produtos
SELECT * FROM produtos;

-- Ver pedidos com detalhes (usando a view criada)
SELECT * FROM pedidos_detalhados;

-- Contar registros
SELECT 
    (SELECT COUNT(*) FROM usuarios) as total_usuarios,
    (SELECT COUNT(*) FROM produtos) as total_produtos,
    (SELECT COUNT(*) FROM pedidos) as total_pedidos;
```

## ❌ Problemas Comuns

### "Could not connect to server"
- ✅ Verifique se usou `postgres` como host (não `localhost`)
- ✅ Confirme que os containers estão rodando: `docker-compose ps`
- ✅ Verifique as credenciais: testuser/testpass

### "Database does not exist"
- ✅ Use `testdb` como database name
- ✅ Verifique se o container PostgreSQL inicializou corretamente

### "Authentication failed"
- ✅ Username: `testuser`
- ✅ Password: `testpass`
- ✅ Database: `testdb`

## 🔄 Reiniciar o Ambiente

Se algo não estiver funcionando:

```bash
# Parar tudo
docker-compose down

# Reiniciar
docker-compose up -d

# Verificar status
docker-compose ps
```

## 📞 Teste Rápido via Terminal

Para confirmar que o banco está funcionando:

```bash
docker exec -it postgres_test psql -U testuser -d testdb -c "\dt"
```

Este comando deve mostrar as 3 tabelas: usuarios, produtos, pedidos.