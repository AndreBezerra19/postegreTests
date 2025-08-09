# 🗄️ Guia de Extensões de Gerenciamento de Banco de Dados para Trae/VS Code

## 📋 Visão Geral

Este guia apresenta as melhores extensões para gerenciamento de bancos de dados diretamente no Trae/VS Code, oferecendo funcionalidades similares ao DBeaver sem sair do ambiente de desenvolvimento.

## 🏆 Extensões Recomendadas

### 1. **SQLTools** (⭐ Mais Recomendada)

**Por que escolher:**
- Suporte a 20+ bancos de dados
- Interface intuitiva e bem integrada
- Comunidade ativa e extensões modulares
- Gratuita e open-source

**Instalação:**
1. Instale a extensão principal: `SQLTools`
2. Instale o driver específico: `SQLTools PostgreSQL/MySQL Driver`
3. Configure a conexão através do painel SQLTools

**Funcionalidades:**
- ✅ Explorador de banco visual
- ✅ Editor SQL com autocomplete
- ✅ Histórico de queries
- ✅ Bookmarks de consultas
- ✅ Exportação de dados (CSV, JSON)
- ✅ Gerador de INSERT queries
- ✅ Formatador SQL

**Configuração Rápida:**
```json
"sqltools.connections": [
  {
    "previewLimit": 50,
    "server": "localhost",
    "port": 5432,
    "driver": "PostgreSQL",
    "name": "PostgreSQL Local",
    "database": "testdb",
    "username": "testuser",
    "password": "testpass"
  }
]
```

### 2. **Database Client** (Alternativa Robusta)

**Características:**
- Interface similar ao DBeaver
- Suporte a MySQL, PostgreSQL, SQLite, Redis, ClickHouse
- Funcionalidades de backup/import
- Geração de dados mock

**Instalação:**
- Busque por "Database Client" no marketplace
- Instale e configure conexões pelo painel lateral

**Funcionalidades:**
- ✅ Visualização de tabelas em grid
- ✅ Editor SQL avançado
- ✅ Backup e restore
- ✅ SSH tunneling
- ✅ Histórico de queries
- ✅ Geração de dados de teste

### 3. **PostgreSQL** (Específico para PostgreSQL)

**Ideal para:**
- Projetos focados exclusivamente em PostgreSQL
- Integração com desenvolvimento Rails
- Diagnósticos avançados

**Funcionalidades:**
- ✅ IntelliSense específico do PostgreSQL
- ✅ Diagnósticos em tempo real
- ✅ Assinaturas de funções
- ✅ Explorador de objetos
- ✅ Detecção de erros inline

### 4. **DBCode** (Premium com Recursos Avançados)

**Características:**
- Interface moderna e intuitiva
- Notebooks SQL interativos
- Compartilhamento seguro de dados
- Gráficos e visualizações

**Funcionalidades Premium:**
- ✅ SQL Notebooks interativos
- ✅ Gráficos e charts
- ✅ Compartilhamento criptografado
- ✅ Queries parametrizadas
- ✅ Suporte a 20+ bancos

## 🚀 Configuração Recomendada (SQLTools)

### Passo 1: Instalação
```bash
# No marketplace do VS Code/Trae:
1. SQLTools
2. SQLTools PostgreSQL/MySQL Driver
```

### Passo 2: Configuração da Conexão
1. Abra o painel SQLTools (ícone de banco na barra lateral)
2. Clique em "Add New Connection"
3. Selecione "PostgreSQL"
4. Configure:
   - **Server**: localhost
   - **Port**: 5432
   - **Database**: testdb
   - **Username**: testuser
   - **Password**: testpass

### Passo 3: Configurações Avançadas

Adicione ao `settings.json`:
```json
{
  "sqltools.useNodeRuntime": true,
  "sqltools.format": {
    "language": "sql",
    "indent": "  "
  },
  "sqltools.results": {
    "limit": 1000,
    "location": "next"
  },
  "sqltools.connections": [
    {
      "previewLimit": 50,
      "server": "localhost",
      "port": 5432,
      "driver": "PostgreSQL",
      "name": "PostgreSQL Local",
      "database": "testdb",
      "username": "testuser",
      "password": "testpass",
      "connectionTimeout": 30
    }
  ]
}
```

## 🔧 Configuração de Formatador SQL

### Opção 1: sqlfmt (Recomendado)
```bash
# Instalar sqlfmt
brew install pipx
pipx install 'shandy-sqlfmt'
```

**Configuração no VS Code:**
```json
{
  "emeraldwalk.runonsave": {
    "commands": [
      {
        "match": "\\.sql$",
        "cmd": "sqlfmt ${file}"
      }
    ]
  }
}
```

### Opção 2: Formatador Integrado
Use o formatador built-in do SQLTools:
- `Ctrl+Shift+P` → "SQLTools: Format SQL"
- Ou configure atalho personalizado

## 📊 Comparação de Funcionalidades

| Funcionalidade | SQLTools | Database Client | PostgreSQL | DBCode |
|---|---|---|---|---|
| **Gratuito** | ✅ | ✅ | ✅ | ⚠️ Freemium |
| **Multi-DB** | ✅ | ✅ | ❌ | ✅ |
| **Autocomplete** | ✅ | ✅ | ✅ | ✅ |
| **Explorador Visual** | ✅ | ✅ | ✅ | ✅ |
| **Backup/Restore** | ❌ | ✅ | ❌ | ✅ |
| **Gráficos** | ❌ | ❌ | ❌ | ✅ |
| **SSH Tunnel** | ✅ | ✅ | ❌ | ✅ |
| **Notebooks** | ❌ | ❌ | ❌ | ✅ |

## 🎯 Recomendação Final

**Para uso geral:** SQLTools + Driver PostgreSQL
- Gratuito, estável e bem mantido
- Excelente integração com VS Code
- Comunidade ativa

**Para PostgreSQL específico:** PostgreSQL Extension
- Diagnósticos avançados
- IntelliSense especializado

**Para recursos premium:** DBCode
- Interface moderna
- Funcionalidades avançadas de visualização

## 🔗 Links Úteis

- [SQLTools Marketplace](https://marketplace.visualstudio.com/items?itemName=mtxr.sqltools)
- [Database Client](https://marketplace.visualstudio.com/items?itemName=cweijan.vscode-database-client2)
- [PostgreSQL Extension](https://marketplace.visualstudio.com/items?itemName=ms-ossdata.vscode-postgresql)
- [DBCode](https://dbcode.io/)

## 🚀 Próximos Passos

1. **Instale SQLTools** e o driver PostgreSQL
2. **Configure a conexão** com seu banco local
3. **Teste as funcionalidades** básicas
4. **Explore recursos avançados** conforme necessário
5. **Configure formatação SQL** para melhor produtividade

---

💡 **Dica:** Comece com SQLTools para ter uma experiência similar ao DBeaver diretamente no Trae!