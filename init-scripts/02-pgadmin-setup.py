#!/usr/bin/env python3
"""
Script para configurar automaticamente a conexão do PostgreSQL no pgAdmin
"""

import json
import os
import time
import requests
from requests.auth import HTTPBasicAuth

def setup_pgadmin_server():
    """Configura automaticamente o servidor PostgreSQL no pgAdmin"""
    
    # Configurações
    pgadmin_url = "http://localhost:8081"
    pgadmin_email = "admin@test.com"
    pgadmin_password = "admin"
    
    # Dados do servidor PostgreSQL
    server_config = {
        "name": "PostgreSQL Local",
        "group_id": 1,
        "host": "postgres",
        "port": 5432,
        "maintenance_db": "testdb",
        "username": "testuser",
        "password": "testpass",
        "ssl_mode": "prefer",
        "comment": "Servidor PostgreSQL para testes"
    }
    
    print("Aguardando pgAdmin inicializar...")
    time.sleep(10)
    
    try:
        # Fazer login no pgAdmin
        session = requests.Session()
        
        # Obter CSRF token
        login_page = session.get(f"{pgadmin_url}/login")
        
        # Fazer login
        login_data = {
            "email": pgadmin_email,
            "password": pgadmin_password
        }
        
        login_response = session.post(f"{pgadmin_url}/authenticate/login", data=login_data)
        
        if login_response.status_code == 200:
            print("Login no pgAdmin realizado com sucesso!")
            
            # Adicionar servidor
            server_response = session.post(
                f"{pgadmin_url}/browser/server/obj/",
                json=server_config,
                headers={"Content-Type": "application/json"}
            )
            
            if server_response.status_code in [200, 201]:
                print("Servidor PostgreSQL adicionado com sucesso ao pgAdmin!")
                print(f"Acesse: {pgadmin_url}")
                print(f"Email: {pgadmin_email}")
                print(f"Senha: {pgadmin_password}")
            else:
                print(f"Erro ao adicionar servidor: {server_response.status_code}")
                print(server_response.text)
        else:
            print(f"Erro no login: {login_response.status_code}")
            
    except Exception as e:
        print(f"Erro: {e}")
        print("\nConfiguração manual:")
        print(f"1. Acesse: {pgadmin_url}")
        print(f"2. Faça login com: {pgadmin_email} / {pgadmin_password}")
        print("3. Clique em 'Add New Server'")
        print("4. Configure:")
        print(f"   - Name: {server_config['name']}")
        print(f"   - Host: {server_config['host']}")
        print(f"   - Port: {server_config['port']}")
        print(f"   - Database: {server_config['maintenance_db']}")
        print(f"   - Username: {server_config['username']}")
        print(f"   - Password: {server_config['password']}")

if __name__ == "__main__":
    setup_pgadmin_server()