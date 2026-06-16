# Requisitos

## Contexto do problema
O texto-base descreve um e-commerce B2B de atacado que precisa atender
gestao de clientes corporativos, representantes comerciais, catalogo com
precificacao dinamica, fluxo de pedidos com aprovacao financeira,
expedicao/logistica e portal do cliente com pos-venda.

## Glossario
- CNPJ: identificador fiscal da empresa.
- Inscricao Estadual: cadastro fiscal estadual da empresa.
- Comprador autorizado: pessoa vinculada a uma empresa com permissao
  para comprar.
- Representante comercial: usuario comercial que atende uma carteira de
  clientes e acompanha comissoes.
- Carteira de clientes: conjunto de clientes atribuidos a um
  representante.
- Comissão: valor gerado a partir de um percentual fixo atrelado ao representante, calculado sobre o valor dos pedidos faturados.
- Tabela de precos: regra de precificacao aplicada por volume de compra
  ou regiao.
- Grade de produtos: variacoes de um produto por cor, tamanho ou
  voltagem.
- Deposito: local de armazenamento de estoque.
- Orcamento: proposta comercial que pode ser convertida em pedido.
- Pedido bloqueado: pedido impedido por exceder o limite de credito.
- Departamento financeiro: area responsavel por analisar pedidos
  bloqueados.
- Picking: lista de separacao de itens para expedicao.
- Packing: etapa de embalagem antes do envio.
- Etiqueta de transporte: identificacao logistica para transporte.
- RMA: solicitacao de troca ou devolucao.
- Segunda via de boleto: novo acesso ao boleto para pagamento.

## Requisitos funcionais
1. Permitir o cadastro de empresas com CNPJ e Inscricao Estadual.
2. Permitir o cadastro de compradores autorizados vinculados as empresas.
3. Gerenciar a hierarquia de representantes comerciais através de relacionamento supervisor-subordinado.
4. Permitir que cada representante visualize apenas sua carteira de clientes e respectivas comissoes.
5. Gerenciar o catalogo de produtos.
6. Permitir multiplas tabelas de precos parametrizadas por faixa de quantidade mínima (volume) ou por Estado/UF do cliente (região).
7. Controlar grades de produtos por cor, tamanho e voltagem.
8. Cadastrar múltiplos depósitos e exibir a disponibilidade de estoque individual por depósito e consolidada.
9. Permitir a criacao de orcamentos.
10. Permitir a conversao de orcamentos em pedidos.
11. Bloquear automaticamente pedidos cujo valor somado aos saldos devedores em aberto exceda o limite de credito pre-aprovado do cliente.
12. Permitir que o departamento financeiro analise, aprove ou reprove manualmente os pedidos bloqueados.
13. Gerar listas de separacao (picking) especificando o depósito de origem após a aprovação do pedido.
14. Gerenciar a etapa de embalagem (packing) apos aprovacao.
15. Emitir etiquetas de transporte contendo os dados logísticos do pedido.
16. Consultar serviço simulado (Mock API) de transportadoras para calculo de frete com base em faixas de CEP e peso.
17. Consultar serviço simulado (Mock API) de transportadoras para atualizacao de status de rastreamento.
18. Disponibilizar um portal do cliente para consulta do historico de compras.
19. Disponibilizar download de segundas vias de boletos no portal do cliente.
20. Permitir a abertura de solicitacoes de troca ou devolucao (RMA).
21. Permitir acompanhamento do status do chamado de RMA.

## Requisitos nao funcionais
1. **Atualização de Estado (Tempo Real):** O aplicativo mobile deve atualizar os status de rastreamento e RMA de forma reativa a cada requisição ou transição de tela, refletindo o estado atual do banco de dados sem necessidade de conexões persistentes (WebSockets).

## Regras de negocio
1. Cada representante deve visualizar apenas a propria carteira de clientes.
2. Cada representante deve visualizar apenas as proprias comissoes.
3. Orcamentos podem ser convertidos em pedidos.
4. Pedidos acima do limite de credito pre-aprovado devem ser bloqueados automaticamente.
5. Pedidos bloqueados devem seguir para analise do departamento financeiro.
6. A expedicao ocorre apos a aprovacao do pedido.
7. O portal do cliente deve permitir consulta de compras, boletos e RMAs.
8. **Cálculo de Comissão:** A comissão do representante é calculada aplicando o seu percentual fixo cadastrado sobre o valor total do pedido no momento em que o status do pedido é alterado para "Aprovado/Faturado".
9. **Hierarquia de Vendas:** Um representante subordinado pode ser vinculado a apenas um supervisor. O supervisor tem permissão para visualizar as carteiras de clientes e comissões de todos os representantes sob sua gestão.
10. **Validação de Crédito:** O limite de crédito é um valor fixo definido manualmente no cadastro do cliente. O limite disponível é recalculado subtraindo o valor dos pedidos com faturamento pendente do limite total pré-aprovado.
11. **Fluxo de Estados do Pedido:** O ciclo de vida de um pedido deve seguir obrigatoriamente a máquina de estados linear:
    * *Orçamento* ➔ *Aguardando Aprovação Financeira* ➔ *Bloqueado no Financeiro* (se estourar crédito) ➔ *Em Embalagem (Picking/Packing)* ➔ *Em Transporte* ➔ *Entregue* ➔ *RMA* (se aplicável).
12. **Consolidação de Estoque:** No catálogo público, a disponibilidade exibida do produto será a soma física do estoque de todos os depósitos cadastrados.

## Restricoes tecnicas ou operacionais
1. O sistema precisa integrar-se a serviços simulados (Mock APIs) de transportadoras para frete e rastreamento, eliminando a dependência de homologações externas no MVP.
2. O banco de dados deve utilizar modelagem relacional para suportar o controle de estoque fracionado em múltiplos depósitos (Tabela N:N).
3. O fluxo depende de informacoes de credito pre-aprovado, aprovacao financeira e status logistico.

## Suposicoes feitas
1. Para fins de escopo do MVP, a validação tributária complexa (como substituição tributária e DIFAL) não será processada pelo sistema, assumindo-se tabelas de preço com valores finais fixados por estado de destino.