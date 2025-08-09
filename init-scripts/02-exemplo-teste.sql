-- Script de exemplo para demonstrar como criar e testar SQL
-- Este arquivo será executado automaticamente após o 01-init.sql

-- Criar uma nova tabela para demonstração
CREATE TABLE IF NOT EXISTS vendas (
    id SERIAL PRIMARY KEY,
    produto_id INTEGER REFERENCES produtos(id),
    usuario_id INTEGER REFERENCES usuarios(id),
    quantidade INTEGER NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(5,2) DEFAULT 0.00,
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserir dados de exemplo
INSERT INTO vendas (produto_id, usuario_id, quantidade, preco_unitario, desconto) VALUES 
    (1, 1, 1, 2500.00, 5.00),
    (2, 2, 2, 50.00, 0.00),
    (3, 3, 1, 150.00, 10.00),
    (4, 1, 1, 800.00, 0.00);

-- Criar uma função para calcular total de vendas
CREATE OR REPLACE FUNCTION calcular_total_vendas()
RETURNS TABLE(
    total_vendas DECIMAL,
    total_desconto DECIMAL,
    vendas_liquidas DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        SUM(quantidade * preco_unitario) as total_vendas,
        SUM(quantidade * preco_unitario * desconto / 100) as total_desconto,
        SUM(quantidade * preco_unitario * (1 - desconto / 100)) as vendas_liquidas
    FROM vendas;
END;
$$ LANGUAGE plpgsql;

-- Criar uma view para relatório de vendas
CREATE OR REPLACE VIEW relatorio_vendas AS
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

-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_vendas_data ON vendas(data_venda);
CREATE INDEX IF NOT EXISTS idx_vendas_produto ON vendas(produto_id);
CREATE INDEX IF NOT EXISTS idx_vendas_usuario ON vendas(usuario_id);