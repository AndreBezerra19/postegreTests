-- Script de testes para validar a funcionalidade do módulo de vendas
-- Execute este script após inicializar o banco para testar as funcionalidades

-- ========================================
-- TESTES DE VALIDAÇÃO
-- ========================================

-- Teste 1: Verificar se as tabelas foram criadas
\echo '=== TESTE 1: Verificando estrutura das tabelas ==='
SELECT 
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns 
WHERE table_name IN ('vendas', 'usuarios', 'produtos')
ORDER BY table_name, ordinal_position;

-- Teste 2: Verificar dados inseridos
\echo '\n=== TESTE 2: Verificando dados inseridos ==='
SELECT 'usuarios' as tabela, COUNT(*) as total_registros FROM usuarios
UNION ALL
SELECT 'produtos' as tabela, COUNT(*) as total_registros FROM produtos
UNION ALL
SELECT 'vendas' as tabela, COUNT(*) as total_registros FROM vendas;

-- Teste 3: Testar a função de cálculo de vendas
\echo '\n=== TESTE 3: Testando função calcular_total_vendas ==='
SELECT * FROM calcular_total_vendas();

-- Teste 4: Testar a view de relatório
\echo '\n=== TESTE 4: Testando view relatorio_vendas ==='
SELECT 
    cliente,
    produto,
    quantidade,
    preco_unitario,
    desconto,
    total_liquido
FROM relatorio_vendas
LIMIT 5;

-- Teste 5: Verificar integridade referencial
\echo '\n=== TESTE 5: Testando integridade referencial ==='
-- Tentar inserir venda com produto inexistente (deve falhar)
\echo 'Tentando inserir venda com produto inexistente (deve falhar):';
DO $$
BEGIN
    INSERT INTO vendas (produto_id, usuario_id, quantidade, preco_unitario) 
    VALUES (999, 1, 1, 100.00);
    RAISE NOTICE 'ERRO: Inserção deveria ter falhado!';
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'OK: Integridade referencial funcionando corretamente';
END $$;

-- Teste 6: Verificar índices criados
\echo '\n=== TESTE 6: Verificando índices criados ==='
SELECT 
    indexname,
    tablename,
    indexdef
FROM pg_indexes 
WHERE tablename IN ('vendas', 'usuarios', 'produtos')
ORDER BY tablename, indexname;

-- Teste 7: Performance - consulta com JOIN
\echo '\n=== TESTE 7: Teste de performance com JOIN ==='
\timing on
SELECT 
    u.nome as cliente,
    COUNT(v.id) as total_vendas,
    SUM(v.quantidade * v.preco_unitario * (1 - v.desconto / 100)) as valor_total
FROM usuarios u
LEFT JOIN vendas v ON u.id = v.usuario_id
GROUP BY u.id, u.nome
ORDER BY valor_total DESC NULLS LAST;
\timing off

-- Teste 8: Validar constraints
\echo '\n=== TESTE 8: Testando constraints ==='
-- Testar constraint de idade (deve falhar)
DO $$
BEGIN
    INSERT INTO usuarios (nome, email, idade) VALUES ('Teste', 'teste@test.com', -5);
    RAISE NOTICE 'ERRO: Constraint de idade não funcionou!';
EXCEPTION
    WHEN check_violation THEN
        RAISE NOTICE 'OK: Constraint de idade funcionando';
END $$;

-- Teste 9: Testar unicidade de email
DO $$
BEGIN
    INSERT INTO usuarios (nome, email, idade) VALUES ('Teste2', 'joao@email.com', 25);
    RAISE NOTICE 'ERRO: Constraint de email único não funcionou!';
EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'OK: Constraint de email único funcionando';
END $$;

\echo '\n=== TODOS OS TESTES CONCLUÍDOS ==='
\echo 'Se não houve erros, o banco está funcionando corretamente!';