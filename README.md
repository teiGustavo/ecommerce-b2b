# ecommerce_b2b

Um projeto Flutter para E-commerce B2B (Atacado).

Documentação do Projeto:

- Arquivo: [Documentação Trabalho Final - PDF](./documentacao_trabalho_final_flutter.pdf).

-
Overleaf: [Documentação Trabalho Final - Overleaf](https://www.overleaf.com/project/6a39c5295711b4fb2b9409be).

---

## Como Executar o Projeto

Este projeto utiliza o **Drift** com SQLite para persistência local e necessita de geração de código
para funcionar corretamente. Siga as instruções abaixo para configurar e rodar o projeto:

### Pré-requisitos

Certifique-se de ter o Flutter instalado em sua máquina (compatível com Dart `^3.12.2` / Flutter
`^3.22.0` ou superior).

### 1. Obter dependências do Flutter

No diretório raiz do projeto, execute:

```bash
flutter pub get
```

### 2. Gerar o banco de dados (Drift / Build Runner)

Como o arquivo gerado do banco de dados `app_database.g.dart` está listado no `.gitignore`, você
precisa gerar as classes do Drift localmente antes de executar ou testar o projeto:

```bash
dart run build_runner build --delete-conflicting-outputs
```

> **Dica**: Durante o desenvolvimento, você pode usar
`dart run build_runner watch --delete-conflicting-outputs` para regenerar os arquivos
> automaticamente sempre que fizer alterações nas tabelas.

### 3. Executar os testes

Para rodar a suíte completa de testes unitários e de integração (incluindo testes específicos com
SQLite em memória para os repositórios do Drift):

```bash
flutter test
```

### 4. Executar o aplicativo

Para rodar o aplicativo em um emulador ou dispositivo conectado:

```bash
flutter run
```

---

## Credenciais de Acesso (Testes):

| E-mail              | Perfil (Role)                            |
|---------------------|------------------------------------------|
| buyer@test.com      | Buyer (Comprador)                        |
| rep@test.com        | Representative (Representante Comercial) |
| supervisor@test.com | Supervisor                               |
| finance@test.com    | Finance (Financeiro)                     |

> A senha para todos é: `password123`.

---

## Arquitetura Modelo:

```Plaintext
lib/
│
├── app/                             # Configurações globais do app
│   ├── config/                      # Rotas, temas, cores, injeção de dependência global
│   └── core/                        # Componentes compartilhados por todo o sistema
│       ├── errors/                  # Falhas e exceções (Failure, Exception)
│       ├── usecases/                # Classe base abstrata para UseCases
│       └── utils/                   # Extensões, formatadores, constantes
│
└── modules/                         # O coração do DDD orientado a Features (Módulos)
    └── auth/                        # Exemplo de Feature: Autenticação
        │
        ├── domain/                  # CAMADA DE DOMÍNIO (Regras de Negócio Puras)
        │   ├── entities/            # Entidades de Negócio (ex: User)
        │   ├── value_objects/       # Objetos de Valor (ex: Email, Password com validações)
        │   ├── repositories/        # Interfaces/Contratos dos Repositórios
        │   └── usecases/            # Casos de Uso (ex: LoginWithEmail, Logout)
        │
        ├── data/                    # CAMADA DE DADOS (Infraestrutura)
        │   ├── datasources/         # Fontes de dados (AuthRemoteDataSource, AuthLocalDataSource)
        │   ├── models/              # Modelos de dados (ex: UserModel que herda de User + toJson/fromJson)
        │   └── repositories/        # Implementações dos repositórios do domínio
        │
        └── presentation/            # CAMADA DE APRESENTAÇÃO (Interface e Estado)
            ├── controllers/         # Gerenciamento de estado (Bloc, Cubit, Controller, Notifier)
            ├── pages/               # Telas completas (LoginPage, RegisterPage)
            └── widgets/             # Componentes visuais exclusivos dessa feature
```

---

## Divisão dos módulos

```Plaintext
lib/modules/
├── customer_management/      # Gestão de Empresas (Clientes B2B), Compradores Autorizados e Limite de Crédito
├── sales_team/               # Representantes de Venda, Hierarquia de Supervisão, Carteira e Comissões
├── catalog/                  # Produtos, Grades de Itens e Tabelas de Preço
├── inventory/                # Controle de Estoque, Alocação, Reservas de Itens e Gestão de Armazém (Warehouse)
├── order_flow/               # Fluxo de Orçamentos (Quotes), Pedidos de Venda (Sales Orders) e Liberação Financeira
├── logistics/                # Fluxo de Expedição (Picking, Packing), Etiquetas, Rastreamento e Frete
├── customer_portal/          # Portal do Cliente, Histórico de Compras, Download de Boletos e Devoluções (RMA)
├── identity_access/          # Controle de Autenticação, Login, Gerenciamento de Sessão e Perfis de Acesso (Roles)
└── shared_kernel/            # Núcleo Compartilhado: Classes base de DDD (Entity, ValueObject) e Objetos comuns (Cnpj, Money, Address)
```

---

## Persistência de Dados (SQLite & Drift)

O aplicativo utiliza o **SQLite** como banco de dados embarcado local, gerenciado de forma reativa
pelo ORM **Drift**.

* **Funcionamento:** Toda a persistência de dados ocorre diretamente no dispositivo do usuário de
  maneira embarcada. Não é necessário baixar ou instalar nenhum servidor de banco de dados externo.
* **Armazenamento:** O arquivo físico do banco de dados (`db.sqlite`) reside em uma pasta de sistema
  privada e segura atribuída ao aplicativo pelo sistema operacional (via `path_provider`).
* **Ambiente de Testes:** Durante a execução de testes automatizados (`flutter test`), o SQLite roda
  **100% em memória RAM** (`NativeDatabase.memory()`). Isso garante que os testes sejam rápidos,
  isolados e que o banco seja descartado imediatamente após a conclusão dos testes.