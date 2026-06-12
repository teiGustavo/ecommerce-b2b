# E-commerce B2B (Atacado)

## Especificação do Trabalho

### Gestão de Clientes Corporativos e Representantes:

O sistema deve permitir o cadastro de empresas (CNPJ, Inscrição Estadual) e seus compradores autorizados.  
Deve gerenciar a hierarquia de representantes comerciais, permitindo que cada um visualize 
apenas sua carteira de clientes e respectivas comissões.

---

### Catálogo de Produtos e Preços Dinâmicos:

O sistema deve gerenciar o catálogo com suporte a múltiplas tabelas de preços 
(baseadas no volume de compra ou região).  
Deve permitir o controle de grades de produtos (cor, tamanho, voltagem) 
e exibir a disponibilidade de estoque em diferentes depósitos.

---

### Gestão de Pedidos e Fluxo de Aprovação:

O sistema deve permitir a criação de orçamentos que podem ser convertidos em pedidos.  
Caso o valor exceda o limite de crédito pré-aprovado do cliente, o pedido deve ser bloqueado
automaticamente para análise do departamento financeiro.

---

### Logística de Expedição e Entrega:

Após a aprovação, o sistema deve gerar listas de separação (picking), 
gerenciar a embalagem (packing) e emitir etiquetas de transporte.  
Deve integrar-se a APIs de transportadoras para
cálculo de frete e atualização do status de rastreamento.

---

### Portal do Cliente e Pós-Venda:

O cliente deve ter acesso a um portal para consultar histórico de compras e baixar segundas
vias de boletos.  
Deve permitir a abertura de solicitações de troca ou devolução (RMA),
acompanhando o status do chamado em tempo real.

---

## Orientações

### 1.1 Objetivos
O objetivo deste trabalho é aplicar os conceitos da disciplina de Engenharia de Software por meio do desenvolvimento de um software completo, baseado em uma especificação sorteada em sala de aula para cada grupo. O desenvolvimento deverá seguir o Processo Unificado (PU), passando por todas as suas fases: Iniciação, Elaboração, Construção e Transição.

Durante o desenvolvimento, o grupo deverá:
* Criar o Diagrama de Entidade e Relacionamento do sistema;
* Implementar os scripts SQL com a estrutura do banco de dados, utilizando comandos DDL (*Data Definition Language*), e garantindo que o banco de dados seja implementado em MariaDB ou MySQL;
* Desenvolver a aplicação utilizando a linguagem e *frameworks* propostos na disciplina de Programação para Dispositivos Móveis, entre outras tecnologias que serão sugeridas durante as aulas;
* Produzir a documentação completa do projeto de acordo com o modelo apresentado em sala de aula: [Link para o modelo](https://www.overleaf.com/read/zkknngwjfcrh#b9a0c4);
* Criar um repositório no Git do projeto com o objetivo de gerenciar as iterações através de *branches*, conforme projeto exemplo: [Link Projeto Exemplo: Controle de Endereços em Flutter](https://github.com/dutrapaulovm/flutter_controle_enderecos).

### 1.2 Instruções
O grupo deverá entregar o trabalho na plataforma SIGAA. Não serão aceitos trabalhos fora do prazo, bem como enviados por e-mail ou qualquer outra plataforma que não seja o SIGAA. Caso haja algum imprevisto, o aluno deverá informar com antecedência de no mínimo 24 horas.

Como se trata de um projeto completo, o trabalho deverá ser compactado. Qualquer outro formato fará com que a atividade seja considerada como não entregue. Certifique-se de que o arquivo compactado possua todos os arquivos antes de enviar e de que não está corrompido. Caso o arquivo compactado seja enviado corrompido ou vazio, será considerado como atividade não entregue.

Como alternativa de **BACKUP** de envio, vocês podem colocar os projetos no Google Drive ou OneDrive e enviar o link de compartilhamento também no SIGAA. Entretanto, **CUIDADO**: certifique-se de que enviou o link corretamente. Lembre-se de configurar o compartilhamento do link como público para que seja possível a visualização. É altamente recomendado utilizar a opção de envio também pelas plataformas citadas anteriormente.

> ⚠️ **ATENÇÃO:** Ao enviar o trabalho pelo GitHub, Google Drive, OneDrive ou qualquer outra plataforma de compartilhamento de arquivos, **NÃO TENTE ATUALIZAR O PROJETO APÓS A DATA DE ENTREGA**. Se isso ocorrer, será considerado como atividade entregue fora do prazo e a nota será **0 (Zero)**. Lembre-se de que a última data de atualização dos arquivos fica visível na plataforma.

Os seguintes arquivos deverão ser entregues:
* Script DDL contendo a estrutura da base de dados (extensão `.sql`);
* Documentação do projeto seguindo o modelo apresentado em sala de aula: [Link para o modelo](https://www.overleaf.com/read/zkknngwjfcrh#b9a0c4);
* Projeto completo desenvolvido na linguagem de sua escolha, incluindo todas as interfaces, funcionalidades e lógica de negócio;
* Modelo de Entidade e Relacionamento no formato de imagem ou PDF. Deverá ser incluído também o arquivo fonte do diagrama de entidade e relacionamento;
* Link para o repositório do projeto no GitHub.

**Observação:** Os scripts SQL devem ser entregues obrigatoriamente em arquivos com a extensão `.sql`. Arquivos enviados em formatos diferentes não serão aceitos.
