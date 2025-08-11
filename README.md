# Sistema de Gerenciamento de Pedidos e Pagamentos de Fornecedores

## Descrição

Este é um sistema web para gerenciamento de pedidos e pagamentos entre fornecedores e usuários. O sistema permite que fornecedores cadastrem produtos e usuários realizem compras, com controle de saldo, histórico de transações e gestão completa de pedidos.

### Funcionalidades Principais

- **Para Fornecedores**: Cadastro de produtos com preços e descontos
- **Para Usuários**: Compra de produtos, controle de saldo e histórico de transações
- **Sistema de Pagamentos**: Depósitos, controle de saldo e processamento automático
- **Gestão de Pedidos**: Status de pedidos, confirmação e cancelamento

## Pré-requisitos

Antes de executar o projeto, você precisa ter instalado:

- **Java 21** (JDK)
- **Maven 3.6+**
- **PostgreSQL 12+**
- **Git** (para clonar o repositório)

## Configuração do Banco de Dados

### 1. Instalar PostgreSQL

Baixe e instale o PostgreSQL em: https://www.postgresql.org/download/

### 2. Criar o Banco de Dados

Após instalar o PostgreSQL, crie um banco de dados:

```sql
CREATE DATABASE supplier_orders;
```

**Ou** crie com outro nome e modifique o `application.properties` (veja configuração abaixo).

### 3. Configurar application.properties

Edite o arquivo `src/main/resources/application.properties`:

```properties
# Configuração do banco de dados
spring.datasource.url=jdbc:postgresql://localhost:5432/supplier_orders
spring.datasource.username=postgres
spring.datasource.password=SUA_SENHA_AQUI
```

**Importante**: 
- Substitua `SUA_SENHA_AQUI` pela senha do seu PostgreSQL
- Se criou o banco com outro nome, altere `supplier_orders` no URL

## Como Executar

### 1. Clonar o Repositório
```bash
git clone [URL_DO_REPOSITORIO]
cd supplier-orders-api
```

### 2. Executar o Projeto
```bash
# Usando Maven
mvn spring-boot:run

# Ou usando o wrapper do Maven
./mvnw spring-boot:run
```

### 3. Acessar a Aplicação
- **Login**: http://localhost:8080/login
- **Registro**: http://localhost:8080/register

## Telas do Sistema

### Autenticação
- **Login** (`/login`): Tela de autenticação para usuários e fornecedores
- **Registro** (`/register`): Cadastro de novos usuários e fornecedores

### Área do Cliente
- **Produtos** (`/buy-products`): Catálogo de produtos disponíveis para compra
- **Carrinho** (`/cart`): Visualização e gestão dos pedidos no carrinho
- **Depósito** (`/deposit`): Área para adicionar saldo à conta
- **Histórico** (`/transaction-history`): Histórico completo de transações

### Área do Fornecedor
- **Produtos** (`/products`): Gestão de produtos (cadastro, edição, exclusão)
- **Histórico** (`/transaction-history`): Histórico completo de transações

## Tecnologias Utilizadas

- **Backend**: Spring Boot 3.5.4, Spring Security, Spring Data JPA
- **Banco de Dados**: PostgreSQL com Flyway para migrações
- **Frontend**: JSP (JavaServer Pages) com CSS moderno
- **Autenticação**: JWT (JSON Web Tokens)
- **Build**: Maven
- **Java**: JDK 21