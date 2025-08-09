-- Script para criar banco de dados SQLite de exemplo
-- Execute com: sqlite3 exemplo.db < criar-banco.sql

-- Criar tabela de usuários
CREATE TABLE IF NOT EXISTS usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    idade INTEGER CHECK (idade >= 0),
    data_criacao DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Inserir dados de exemplo
INSERT INTO usuarios (nome, email, idade) VALUES 
    ('João Silva', 'joao@email.com', 30),
    ('Maria Santos', 'maria@email.com', 25),
    ('Pedro Oliveira', 'pedro@email.com', 35),
    ('Ana Costa', 'ana@email.com', 28);

-- Criar tabela de produtos
CREATE TABLE IF NOT EXISTS produtos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    preco REAL NOT NULL,
    categoria TEXT,
    estoque INTEGER DEFAULT 0,
    ativo BOOLEAN DEFAULT 1
);

-- Inserir produtos
INSERT INTO produtos (nome, preco, categoria, estoque) VALUES 
    ('Notebook Dell', 2500.00, 'Eletrônicos', 10),
    ('Mouse Logitech', 50.00, 'Periféricos', 25),
    ('Teclado Mecânico', 150.00, 'Periféricos', 15),
    ('Monitor 24"', 800.00, 'Eletrônicos', 8);

-- Criar tabela de vendas
CREATE TABLE IF NOT EXISTS vendas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    produto_id INTEGER REFERENCES produtos(id),
    usuario_id INTEGER REFERENCES usuarios(id),
    quantidade INTEGER NOT NULL,
    preco_unitario REAL NOT NULL,
    desconto REAL DEFAULT 0.00,
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Inserir vendas
INSERT INTO vendas (produto_id, usuario_id, quantidade, preco_unitario, desconto) VALUES 
    (1, 1, 1, 2500.00, 5.00),
    (2, 2, 2, 50.00, 0.00),
    (3, 3, 1, 150.00, 10.00),
    (4, 1, 1, 800.00, 0.00);

-- Criar view para relatório
CREATE VIEW IF NOT EXISTS relatorio_vendas AS
SELECT 
    v.id,
    u.nome as cliente,
    p.nome as produto,
    v.quantidade,
    v.preco_unitario,
    v.desconto,
    (v.quantidade * v.preco_unitario) as subtotal,
    (v.quantidade * v.preco_unitario * v.desconto / 100) as valor_desconto,
    (v.quantidade * v.preco_unitario * (1 - v.desconto / 100)) as total_liquido,
    v.data_venda
FROM vendas v
JOIN usuarios u ON v.usuario_id = u.id
JOIN produtos p ON v.produto_id = p.id
ORDER BY v.data_venda DESC;

-- Criar índices
CREATE INDEX IF NOT EXISTS idx_usuarios_email ON usuarios(email);
CREATE INDEX IF NOT EXISTS idx_vendas_data ON vendas(data_venda);
CREATE INDEX IF NOT EXISTS idx_vendas_produto ON vendas(produto_id);

-- Mensagem de sucesso
SELECT 'Banco de dados criado com sucesso!' as status;