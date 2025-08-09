-- Script de testes para validar o banco SQLite
-- Execute com: sqlite3 exemplo.db < testar-banco.sql

-- Configurar saída formatada
.headers on
.mode table
.width 15 20 15 10

-- Teste 1: Verificar estrutura das tabelas
.print '=== TESTE 1: Estrutura das Tabelas ==='
SELECT name as tabela, type as tipo 
FROM sqlite_master 
WHERE type IN ('table', 'view')
ORDER BY name;

-- Teste 2: Contar registros
.print '\n=== TESTE 2: Contagem de Registros ==='
SELECT 'usuarios' as tabela, COUNT(*) as total FROM usuarios
UNION ALL
SELECT 'produtos' as tabela, COUNT(*) as total FROM produtos
UNION ALL
SELECT 'vendas' as tabela, COUNT(*) as total FROM vendas;

-- Teste 3: Verificar dados dos usuários
.print '\n=== TESTE 3: Dados dos Usuários ==='
SELECT id, nome, email, idade FROM usuarios;

-- Teste 4: Verificar produtos em estoque
.print '\n=== TESTE 4: Produtos em Estoque ==='
SELECT nome, preco, categoria, estoque 
FROM produtos 
WHERE estoque > 0
ORDER BY estoque DESC;

-- Teste 5: Relatório de vendas
.print '\n=== TESTE 5: Relatório de Vendas ==='
SELECT 
    cliente,
    produto,
    quantidade,
    printf('R$ %.2f', preco_unitario) as preco,
    printf('%.1f%%', desconto) as desconto,
    printf('R$ %.2f', total_liquido) as total
FROM relatorio_vendas;

-- Teste 6: Estatísticas de vendas
.print '\n=== TESTE 6: Estatísticas de Vendas ==='
SELECT 
    COUNT(*) as total_vendas,
    printf('R$ %.2f', SUM(quantidade * preco_unitario)) as faturamento_bruto,
    printf('R$ %.2f', SUM(quantidade * preco_unitario * desconto / 100)) as total_descontos,
    printf('R$ %.2f', SUM(quantidade * preco_unitario * (1 - desconto / 100))) as faturamento_liquido
FROM vendas;

-- Teste 7: Top clientes
.print '\n=== TESTE 7: Top Clientes ==='
SELECT 
    u.nome as cliente,
    COUNT(v.id) as total_compras,
    printf('R$ %.2f', SUM(v.quantidade * v.preco_unitario * (1 - v.desconto / 100))) as valor_total
FROM usuarios u
LEFT JOIN vendas v ON u.id = v.usuario_id
GROUP BY u.id, u.nome
ORDER BY valor_total DESC;

-- Teste 8: Verificar índices
.print '\n=== TESTE 8: Índices Criados ==='
SELECT name as indice, tbl_name as tabela
FROM sqlite_master 
WHERE type = 'index' AND name NOT LIKE 'sqlite_%'
ORDER BY tbl_name, name;

-- Teste 9: Testar constraint de idade
.print '\n=== TESTE 9: Testando Constraints ==='
-- Este teste vai falhar propositalmente para mostrar que a constraint funciona
INSERT INTO usuarios (nome, email, idade) VALUES ('Teste Constraint', 'teste@constraint.com', -5);

.print '\n=== TODOS OS TESTES CONCLUÍDOS ==='
.print 'Se chegou até aqui, o banco está funcionando corretamente!';
.print 'Nota: O último teste (constraint de idade) deve ter falhado, isso é esperado.';