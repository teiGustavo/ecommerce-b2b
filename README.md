# ecommerce_b2b

Um projeto Flutter para E-commerce B2B (Atacado).

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

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

No desenvolvimento Flutter, a comunidade acabou adotando uma fusão:
Uniu-se o conceito de três camadas principais da Clean Architecture (presentation, domain, data) 
com as ferramentas táticas do DDD (entities, value_objects) dentro da camada de domínio.

```Plaintext
lib/modules/
├── customer_management/      # Gestão de Empresas, Compradores e Crédito
├── sales_team/               # Representantes, Supervisão, Carteira e Comissões
├── catalog/                  # Produtos, Grades, Estoque e Tabelas de Preço
├── order_flow/               # Orçamentos, Pedidos e Aprovação Financeira
├── logistics/                # Picking, Packing, Etiquetas e Cálculo de Frete (Mock API)
└── customer_portal/          # Portal do Cliente, Segunda Via de Boleto e RMA
```

Ordem de Implementação: 

1. customer_management
2. sales_team
3. catalog
4. inventory
5. order_flow
6. logistics
7. customer_portal