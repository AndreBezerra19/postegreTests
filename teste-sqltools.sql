-- 🔍 Teste de Conexão SQLTools com PostgreSQL Docker
-- Execute este arquivo para verificar se a conexão está funcionando

-- 1. Verificar versão do PostgreSQL
SELECT version();

-- 2. Listar todas as tabelas do banco
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;

-- 3. Verificar dados dos usuários
SELECT 
    id,
    nome,
    email,
    idade,
    data_criacao
FROM usuarios
LIMIT 10;

-- 4. Verificar dados dos produtos
SELECT 
    id,
    nome,
    preco,
    estoque,
    categoria
FROM produtos
LIMIT 10;

-- 5. Verificar dados das vendas (se existir)
SELECT 
    id,
    usuario_id,
    produto_id,
    quantidade,
    preco_unitario,
    data_venda
FROM vendas
LIMIT 10;

-- 6. Consulta com JOIN para relatório
SELECT 
    u.nome as cliente,
    p.nome as produto,
    v.quantidade,
    v.preco_unitario,
    (v.quantidade * v.preco_unitario) as total,
    v.data_venda
FROM vendas v
JOIN usuarios u ON v.usuario_id = u.id
JOIN produtos p ON v.produto_id = p.id
ORDER BY v.data_venda DESC
LIMIT 20;

-- 7. Estatísticas gerais
SELECT 
    'Usuários' as tabela,
    COUNT(*) as total_registros
FROM usuarios

UNION ALL

SELECT 
    'Produtos' as tabela,
    COUNT(*) as total_registros
FROM produtos

UNION ALL

SELECT 
    'Vendas' as tabela,
    COUNT(*) as total_registros
FROM vendas;

-- 8. Testar função personalizada
SELECT calcular_total_vendas() as total_vendas_geral;