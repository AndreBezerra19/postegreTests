# 📝 Guia Completo: Como Criar e Testar Scripts SQL

Este guia mostra como criar, executar e testar scripts SQL usando o ambiente PostgreSQL configurado.

## 🚀 Passo a Passo

### 1. Iniciar o Ambiente

```bash
# Navegar para o diretório do projeto
cd /Users/andrebezerra/Desktop/Dev/PostgresTests

# Iniciar os containers
docker-compose up -d

# Verificar se estão rodando
docker-compose ps
```

### 2. Métodos para Executar Scripts SQL

#### Método 1: Via linha de comando (psql)
```bash
# Conectar ao banco
docker exec -it postgres_test psql -U testuser -d testdb

# Executar comandos SQL diretamente
SELECT * FROM usuarios;

# Executar arquivo SQL
\i /scripts-teste/teste-vendas.sql

# Sair do psql
\q
```

#### Método 2: Executar arquivo SQL externamente
```bash
# Executar script de teste
docker exec -i postgres_test psql -U testuser -d testdb < scripts-teste/teste-vendas.sql

# Executar script com saída formatada
docker exec -i postgres_test psql -U testuser -d testdb -f scripts-teste/teste-vendas.sql
```

#### Método 3: Via pgAdmin (Interface Web)
1. Acesse: http://localhost:8081
2. Login: admin@test.com / admin
3. Conecte ao servidor PostgreSQL
4. Abra o Query Tool
5. Cole ou digite seu SQL
6. Execute com F5 ou botão ▶️

### 3. Estrutura para Novos Scripts

#### Scripts de Inicialização (init-scripts/)
- Executados automaticamente na criação do container
- Nomeados em ordem: `01-init.sql`, `02-exemplo-teste.sql`, etc.
- Usados para criar estrutura inicial do banco

#### Scripts de Teste (scripts-teste/)
- Executados manualmente para validar funcionalidades
- Contêm testes de integridade, performance e validação
- Podem ser executados repetidamente

### 4. Template para Novo Script SQL

```sql
-- ========================================
-- NOME DO SCRIPT: [Descreva o propósito]
-- AUTOR: [Seu nome]
-- DATA: [Data de criação]
-- ========================================

-- Verificar se já existe (para scripts reutilizáveis)
-- DROP TABLE IF EXISTS nova_tabela;

-- Criar estrutura
CREATE TABLE IF NOT EXISTS nova_tabela (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserir dados de exemplo
INSERT INTO nova_tabela (nome) VALUES 
    ('Exemplo 1'),
    ('Exemplo 2');

-- Criar índices se necessário
CREATE INDEX IF NOT EXISTS idx_nova_tabela_nome ON nova_tabela(nome);

-- Comentários explicativos
COMMENT ON TABLE nova_tabela IS 'Descrição da tabela';
COMMENT ON COLUMN nova_tabela.nome IS 'Nome do registro';
```

### 5. Template para Script de Teste

```sql
-- ========================================
-- SCRIPT DE TESTE: [Nome da funcionalidade]
-- ========================================

\echo '=== INICIANDO TESTES ===';

-- Teste 1: Verificar estrutura
\echo 'Teste 1: Verificando se tabela existe';
SELECT COUNT(*) as tabela_existe 
FROM information_schema.tables 
WHERE table_name = 'nova_tabela';

-- Teste 2: Verificar dados
\echo 'Teste 2: Contando registros';
SELECT COUNT(*) as total_registros FROM nova_tabela;

-- Teste 3: Testar funcionalidade
\echo 'Teste 3: Testando inserção';
INSERT INTO nova_tabela (nome) VALUES ('Teste');
SELECT * FROM nova_tabela WHERE nome = 'Teste';

-- Limpeza (opcional)
DELETE FROM nova_tabela WHERE nome = 'Teste';

\echo '=== TESTES CONCLUÍDOS ===';
```

## 🔧 Comandos Úteis para Desenvolvimento

### Verificar estrutura do banco
```sql
-- Listar todas as tabelas
\dt

-- Descrever estrutura de uma tabela
\d nome_da_tabela

-- Listar todas as funções
\df

-- Listar todas as views
\dv

-- Ver índices de uma tabela
\di nome_da_tabela
```

### Comandos de debug
```sql
-- Ver plano de execução
EXPLAIN ANALYZE SELECT * FROM usuarios;

-- Verificar locks
SELECT * FROM pg_locks;

-- Ver processos ativos
SELECT * FROM pg_stat_activity;

-- Estatísticas de tabela
SELECT * FROM pg_stat_user_tables WHERE relname = 'usuarios';
```

### Backup e Restore
```bash
# Fazer backup
docker exec postgres_test pg_dump -U testuser testdb > backup_$(date +%Y%m%d).sql

# Restaurar backup
docker exec -i postgres_test psql -U testuser testdb < backup_20231201.sql

# Backup de uma tabela específica
docker exec postgres_test pg_dump -U testuser -t usuarios testdb > usuarios_backup.sql
```

## 🧪 Exemplos de Testes Avançados

### Teste de Performance
```sql
-- Medir tempo de execução
\timing on
SELECT COUNT(*) FROM usuarios;
\timing off

-- Teste com dados grandes
INSERT INTO usuarios (nome, email, idade)
SELECT 
    'Usuario ' || generate_series,
    'user' || generate_series || '@test.com',
    (random() * 80 + 18)::integer
FROM generate_series(1, 10000);
```

### Teste de Integridade
```sql
-- Testar constraints
DO $$
BEGIN
    -- Código que deve falhar
    INSERT INTO usuarios (nome, email, idade) VALUES ('Test', 'invalid', -1);
    RAISE EXCEPTION 'Teste falhou: constraint não funcionou';
EXCEPTION
    WHEN check_violation THEN
        RAISE NOTICE 'OK: Constraint funcionando';
END $$;
```

## 📊 Monitoramento e Logs

```bash
# Ver logs do PostgreSQL
docker-compose logs postgres

# Seguir logs em tempo real
docker-compose logs -f postgres

# Ver logs do pgAdmin
docker-compose logs pgadmin
```

## 🔄 Workflow Recomendado

1. **Desenvolvimento**:
   - Criar script na pasta `scripts-teste/`
   - Testar via psql ou pgAdmin
   - Refinar e otimizar

2. **Validação**:
   - Criar script de teste correspondente
   - Executar testes automatizados
   - Verificar performance

3. **Deploy**:
   - Mover script final para `init-scripts/` (se for estrutural)
   - Ou manter em `scripts-teste/` (se for operacional)
   - Documentar no README

4. **Manutenção**:
   - Executar testes regularmente
   - Monitorar performance
   - Atualizar documentação

Este ambiente fornece tudo que você precisa para desenvolver e testar scripts SQL de forma profissional! 🚀