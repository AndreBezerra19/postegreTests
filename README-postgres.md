# Ambiente PostgreSQL para Testes

Este ambiente Docker fornece uma instância completa do PostgreSQL com pgAdmin para testes e desenvolvimento.

## 🚀 Como usar

### 1. Iniciar os containers
```bash
docker-compose up -d
```

### 2. Verificar se os containers estão rodando
```bash
docker-compose ps
```

### 3. Conectar ao PostgreSQL

#### Via linha de comando (psql)
```bash
docker exec -it postgres_test psql -U testuser -d testdb
```

#### Via pgAdmin (Interface Web)
- Acesse: http://localhost:8081
- Email: admin@test.com
- Senha: admin

**Configuração da conexão no pgAdmin:**
- Host: postgres
- Port: 5432
- Database: testdb
- Username: testuser
- Password: testpass

#### Via aplicação externa
- Host: localhost
- Port: 5432
- Database: testdb
- Username: testuser
- Password: testpass

## 📊 Dados de Exemplo

O banco já vem com dados de exemplo:

### Tabelas criadas:
- `usuarios` - Tabela de usuários com dados pessoais
- `produtos` - Catálogo de produtos
- `pedidos` - Relacionamento entre usuários e produtos

### Consultas de exemplo:

```sql
-- Listar todos os usuários
SELECT * FROM usuarios;

-- Listar produtos em estoque
SELECT * FROM produtos WHERE estoque > 0;

-- Ver pedidos detalhados (usando a view criada)
SELECT * FROM pedidos_detalhados;

-- Calcular idade média dos usuários (usando função criada)
SELECT calcular_idade_media();

-- Consulta com JOIN
SELECT 
    u.nome,
    COUNT(p.id) as total_pedidos,
    SUM(pr.preco * p.quantidade) as valor_total
FROM usuarios u
LEFT JOIN pedidos p ON u.id = p.usuario_id
LEFT JOIN produtos pr ON p.produto_id = pr.id
GROUP BY u.id, u.nome;
```

## 🛠️ Comandos úteis

### Parar os containers
```bash
docker-compose down
```

### Parar e remover volumes (apaga dados)
```bash
docker-compose down -v
```

### Ver logs do PostgreSQL
```bash
docker-compose logs postgres
```

### Backup do banco
```bash
docker exec postgres_test pg_dump -U testuser testdb > backup.sql
```

### Restaurar backup
```bash
docker exec -i postgres_test psql -U testuser testdb < backup.sql
```

## 📁 Estrutura do projeto

```
.
├── docker-compose.yml          # Configuração dos containers
├── init-scripts/               # Scripts executados na inicialização
│   └── 01-init.sql            # Criação de tabelas e dados de exemplo
└── README-postgres.md         # Este arquivo
```

## 🔧 Personalização

### Adicionar novos scripts de inicialização
Coloque arquivos `.sql` na pasta `init-scripts/`. Eles serão executados em ordem alfabética.

### Alterar configurações
Edite o arquivo `docker-compose.yml` para:
- Mudar portas
- Alterar credenciais
- Adicionar variáveis de ambiente
- Configurar volumes adicionais

### Extensões PostgreSQL
Para adicionar extensões, crie um script em `init-scripts/`:
```sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";
```

## 🐛 Troubleshooting

### Porta 5432 já está em uso
Se você já tem PostgreSQL instalado localmente, altere a porta no docker-compose.yml:
```yaml
ports:
  - "5433:5432"  # Usar porta 5433 no host
```

### Problemas de permissão
Se houver problemas com volumes, tente:
```bash
sudo chown -R $USER:$USER .
```

### Reset completo
```bash
docker-compose down -v
docker-compose up -d
```