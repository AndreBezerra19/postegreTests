-- Script de inicialização para testes do PostgreSQL
-- Este script será executado automaticamente quando o container for criado

-- Criar uma tabela de exemplo para testes
CREATE TABLE IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    idade INTEGER CHECK (idade >= 0),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserir alguns dados de exemplo
INSERT INTO usuarios (nome, email, idade) VALUES 
    ('João Silva', 'joao@email.com', 30),
    ('Maria Santos', 'maria@email.com', 25),
    ('Pedro Oliveira', 'pedro@email.com', 35),
    ('Ana Costa', 'ana@email.com', 28);

-- Criar uma tabela de produtos para demonstrar relacionamentos
CREATE TABLE IF NOT EXISTS produtos (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(50),
    estoque INTEGER DEFAULT 0,
    ativo BOOLEAN DEFAULT true
);

-- Inserir produtos de exemplo
INSERT INTO produtos (nome, preco, categoria, estoque) VALUES 
    ('Notebook Dell', 2500.00, 'Eletrônicos', 10),
    ('Mouse Logitech', 50.00, 'Periféricos', 25),
    ('Teclado Mecânico', 150.00, 'Periféricos', 15),
    ('Monitor 24"', 800.00, 'Eletrônicos', 8);

-- Criar uma tabela de pedidos para demonstrar relacionamentos
CREATE TABLE IF NOT EXISTS pedidos (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id),
    produto_id INTEGER REFERENCES produtos(id),
    quantidade INTEGER NOT NULL DEFAULT 1,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserir alguns pedidos de exemplo
INSERT INTO pedidos (usuario_id, produto_id, quantidade) VALUES 
    (1, 1, 1),
    (2, 2, 2),
    (3, 3, 1),
    (1, 4, 1),
    (4, 2, 3);

-- Criar um índice para melhorar performance em consultas por email
CREATE INDEX IF NOT EXISTS idx_usuarios_email ON usuarios(email);

-- Criar uma view para consultas frequentes
CREATE OR REPLACE VIEW pedidos_detalhados AS
SELECT 
    p.id as pedido_id,
    u.nome as usuario_nome,
    u.email as usuario_email,
    pr.nome as produto_nome,
    pr.preco as produto_preco,
    p.quantidade,
    (pr.preco * p.quantidade) as total,
    p.data_pedido
FROM pedidos p
JOIN usuarios u ON p.usuario_id = u.id
JOIN produtos pr ON p.produto_id = pr.id;

-- Função de exemplo para calcular idade
CREATE OR REPLACE FUNCTION calcular_idade_media()
RETURNS DECIMAL AS $$
BEGIN
    RETURN (SELECT AVG(idade) FROM usuarios);
END;
$$ LANGUAGE plpgsql;