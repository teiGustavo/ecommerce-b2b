# Walkthrough: Telas e Formulários

Concluímos a implementação das telas e formulários baseados nas validações de negócio dos *Value Objects* e usando `flutter_bloc` (Cubit), `formz` e `mask_text_input_formatter`.

## Telas Implementadas

### 1. Gestão de Clientes e Compradores
- **Cadastro de Empresa** ([CompanyFormPage](file:///d:/code/ecommerce-b2b/lib/modules/customer_management/presentation/pages/company_form_page.dart)): Formulário completo de cadastro B2B. As validações de CNPJ, Inscrição Estadual (IE), Telefone, E-mail e CEP foram criadas como classes do `FormzInput`, chamando internamente os métodos `.create()` de seus respectivos Value Objects para garantir aderência estrita às regras do domínio (como cálculo de dígito verificador do CNPJ e Regex de E-mail). Todos os inputs visuais agora utilizam a biblioteca de máscaras para melhor UX (ex: `##.###.###/####-##` para CNPJ).
- **Comprador Autorizado** ([AuthorizedBuyerFormPage](file:///d:/code/ecommerce-b2b/lib/modules/customer_management/presentation/pages/authorized_buyer_form_page.dart)): Cadastro de contatos da empresa com validação de telefone (E.164) e e-mail.

### 2. Gestão de Pedidos e Financeiro
- **Carrinho e Orçamento** ([CartPage](file:///d:/code/ecommerce-b2b/lib/modules/order_flow/presentation/pages/cart_page.dart)): Simula o processo de checkout onde a regra de bloqueio de crédito é aplicada. Se o valor do pedido exceder o limite disponível, o status do carrinho reflete "Bloqueado no Financeiro".
- **Revisão Financeira** ([FinanceReviewPage](file:///d:/code/ecommerce-b2b/lib/modules/order_flow/presentation/pages/finance_review_page.dart)): Dashboard voltado ao departamento financeiro para listagem de pedidos bloqueados e controles visuais para Aprovar ou Reprovar a venda excedente.

### 3. Representantes e Catálogo
- **Dashboard de Vendas** ([SalesDashboardPage](file:///d:/code/ecommerce-b2b/lib/modules/sales_team/presentation/pages/sales_dashboard_page.dart)): Permite ao representante visualizar a sua comissão calculada com base nos pedidos faturados e também visualizar a listagem resumida de sua carteira de clientes.
- **Catálogo de Produtos** ([ProductCatalogPage](file:///d:/code/ecommerce-b2b/lib/modules/catalog/presentation/pages/product_catalog_page.dart)): Apresenta a vitrine de produtos exibindo o estoque consolidado (a soma de todos os depósitos) e as diversas variações das grades (Tamanho, Cor, Voltagem) através de pequenos chips/tags.

### 4. Logística e Portal do Cliente
- **Dashboard Logístico** ([LogisticsDashboardPage](file:///d:/code/ecommerce-b2b/lib/modules/logistics/presentation/pages/logistics_dashboard_page.dart)): Contém abas separadas para as etapas de *Picking* (separação listando o depósito) e *Packing* (embalagem com emissão de etiqueta), além de um simulador na interface que aceita CEP de origem, destino e peso para calcular fretes por meio de uma Mock API.
- **Portal do Cliente** ([CustomerPortalPage](file:///d:/code/ecommerce-b2b/lib/modules/customer_portal/presentation/pages/customer_portal_page.dart)): Tela na qual o usuário/comprador logado visualiza o seu histórico de compras, consegue baixar a 2ª via de boletos, e solicita de forma simples um RMA para trocas e devoluções.

## Próximos Passos (User Verification)

> [!TIP]
> **Como Validar Localmente**
> Para conferir as interfaces, você pode alterar o `home` do `MaterialApp` no arquivo principal (`main.dart`) para apontar temporariamente para as telas implementadas, por exemplo: `home: const CompanyFormPage()`.
> 
> Todos os arquivos de formulários e componentes visuais estão implementados respeitando a separação entre estado (`Cubit`) e UI.

O sistema de máscaras (`mask_text_input_formatter`) e validações de formulário complexas via `Formz` já estão em funcionamento para os dados como CNPJ, CEP, Limite de Crédito Monetário e Inscrição Estadual.
