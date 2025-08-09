# 🔧 Guia de Configuração SQLTools + PostgreSQL Docker

## 📋 Pré-requisitos

✅ Docker rodando com PostgreSQL  
✅ Trae/VS Code instalado  
✅ Extensões SQLTools instaladas  

## 🚀 Passo a Passo

### 1. **Instalar Extensões SQLTools**

**No marketplace do Trae/VS Code:**
1. Busque e instale: `SQLTools`
2. Busque e instale: `SQLTools PostgreSQL/MySQL Driver`

### 2. **Verificar PostgreSQL Docker**

```bash
# Verificar se os containers estão rodando
docker ps

# Se não estiverem, iniciar
cd PostgresTests
docker-compose up -d
```

### 3. **Configuração Automática**

✅ **Arquivo já criado:** `.vscode/settings.json`

As configurações incluem:
- **Server:** localhost
- **Port:** 5432
- **Database:** testdb
- **Username:** testuser
- **Password:** testpass
- **Auto-connect:** Habilitado

### 4. **Conectar ao Banco**

**Opção A - Automática:**
1. Recarregue o Trae/VS Code
2. A conexão "PostgreSQL Docker" aparecerá automaticamente

**Opção B - Manual:**
1. Abra o painel SQLTools (ícone de banco na barra lateral)
2. Clique em "Add New Connection"
3. Selecione "PostgreSQL"
4. Use as configurações:
   ```
   Connection Name: PostgreSQL Docker
   Server: localhost
   Port: 5432
   Database: testdb
   Username: testuser
   Password: testpass
   ```

### 5. **Testar Conexão**

1. **Abra o arquivo:** `teste-sqltools.sql`
2. **Execute uma query:**
   - Selecione uma linha SQL
   - Pressione `Ctrl+E` `Ctrl+E` (ou `Cmd+E` `Cmd+E` no Mac)
   - Ou clique com botão direito → "Run Selected Query"

**Exemplo de teste rápido:**
```sql
SELECT version();
```

### 6. **Explorar o Banco**

**No painel SQLTools:**
- 📁 **PostgreSQL Docker**
  - 📁 **testdb**
    - 📁 **Schemas**
      - 📁 **public**
        - 📁 **Tables**
          - 📄 usuarios
          - 📄 produtos
          - 📄 vendas
        - 📁 **Functions**
          - ⚙️ calcular_total_vendas
        - 📁 **Views**
          - 👁️ relatorio_vendas

## 🎯 Funcionalidades Principais

### **1. Autocomplete Inteligente**
- Digite `SELECT * FROM ` e veja as sugestões de tabelas
- Autocomplete de colunas após especificar a tabela
- Sugestões de funções PostgreSQL

### **2. Explorador Visual**
- Clique em qualquer tabela para ver sua estrutura
- Botão direito → "Show Table Records" para ver dados
- Expandir/colapsar schemas e objetos

### **3. Execução de Queries**
- **Query selecionada:** `Ctrl+E` `Ctrl+E`
- **Arquivo inteiro:** `Ctrl+E` `Ctrl+A`
- **Query atual:** Posicione cursor e execute

### **4. Histórico de Queries**
- Painel SQLTools → aba "History"
- Reutilizar queries anteriores
- Salvar queries favoritas

### **5. Exportação de Dados**
- Após executar query → botão "Export"
- Formatos: CSV, JSON, Excel
- Copiar resultados para clipboard

## 🔧 Configurações Avançadas

### **Atalhos Personalizados**

Adicione ao `keybindings.json`:
```json
[
  {
    "key": "f5",
    "command": "sqltools.executeQuery",
    "when": "editorTextFocus && editorLangId == sql"
  },
  {
    "key": "ctrl+shift+e",
    "command": "sqltools.executeQueryFromFile"
  }
]
```

### **Formatação SQL**

Para formatação automática, adicione ao `settings.json`:
```json
{
  "[sql]": {
    "editor.defaultFormatter": "mtxr.sqltools",
    "editor.formatOnSave": true
  }
}
```

## 🐛 Solução de Problemas

### **Erro: "Connection refused"**
```bash
# Verificar se PostgreSQL está rodando
docker ps | grep postgres

# Reiniciar se necessário
docker-compose restart postgres
```

### **Erro: "Authentication failed"**
- Verificar credenciais no `docker-compose.yml`
- Confirmar configurações no SQLTools

### **Extensão não aparece**
1. Recarregar Trae: `Ctrl+Shift+P` → "Developer: Reload Window"
2. Verificar se ambas extensões estão instaladas
3. Verificar arquivo `.vscode/settings.json`

### **Autocomplete não funciona**
- Aguardar conexão ser estabelecida (ícone verde)
- Verificar se está conectado ao banco correto
- Recarregar conexão no painel SQLTools

## 📊 Queries de Exemplo

### **Análise de Vendas**
```sql
-- Top 5 produtos mais vendidos
SELECT 
    p.nome,
    SUM(v.quantidade) as total_vendido,
    SUM(v.quantidade * v.preco_unitario) as receita_total
FROM vendas v
JOIN produtos p ON v.produto_id = p.id
GROUP BY p.id, p.nome
ORDER BY total_vendido DESC
LIMIT 5;
```

### **Relatório de Clientes**
```sql
-- Clientes com mais compras
SELECT 
    u.nome,
    u.email,
    COUNT(v.id) as total_compras,
    SUM(v.quantidade * v.preco_unitario) as valor_total
FROM usuarios u
LEFT JOIN vendas v ON u.id = v.usuario_id
GROUP BY u.id, u.nome, u.email
ORDER BY valor_total DESC NULLS LAST;
```

## ✅ Checklist de Verificação

- [ ] PostgreSQL Docker rodando
- [ ] SQLTools + Driver PostgreSQL instalados
- [ ] Arquivo `.vscode/settings.json` configurado
- [ ] Conexão "PostgreSQL Docker" aparece no painel
- [ ] Consegue executar `SELECT version();`
- [ ] Autocomplete funcionando
- [ ] Explorador mostra tabelas e dados

## 🎉 Próximos Passos

1. **Explore as tabelas** clicando no explorador
2. **Execute o arquivo** `teste-sqltools.sql` completo
3. **Crie suas próprias queries** e salve no histórico
4. **Configure atalhos** personalizados para maior produtividade
5. **Experimente a exportação** de dados em diferentes formatos

---

💡 **Dica:** Use `Ctrl+Space` para ativar o autocomplete em qualquer momento!