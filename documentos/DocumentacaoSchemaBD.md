# Schema do Banco de Dados

O banco de dados do projeto utiliza PostgreSQL e foi modelado com Prisma ORM, atualmente ele tem tres entidades sendo elas: Cliente, Estilista e Agendamento.

Aqui estão a descrição de cada entidade, seus campos e os relacionamentos entre elas:

## Cliente

Representa o usuário final que solicita atendimentos com estilistas.

| Campo | Tipo | Descrição |
|---|---|---|
| id | Int | Identificador único do cliente |
| nome | String | Nome do cliente |
| email | String | E-mail único do cliente |
| telefone | String | Telefone de contato do cliente |
| createdAt | DateTime | Data de criação do registro |
| updatedAt | DateTime | Data da última atualização |

## Estilista

Representa o prestador de serviço que recebe e responde às solicitações de agendamento.

| Campo | Tipo | Descrição |
|---|---|---|
| id | Int | Identificador único do estilista |
| nome | String | Nome do estilista |
| email | String | E-mail único do estilista |
| telefone | String | Telefone de contato do estilista |
| especialidade | String | Área de atuação ou especialidade do estilista |
| descricao | String? | Descrição profissional do estilista |
| createdAt | DateTime | Data de criação do registro |
| updatedAt | DateTime | Data da última atualização |

## Agendamento

Representa a solicitação feita por um cliente para um estilista.

| Campo | Tipo | Descrição |
|---|---|---|
| id | Int | Identificador único do agendamento |
| clienteId | Int | Identificador do cliente solicitante |
| estilistaId | Int | Identificador do estilista solicitado |
| data | DateTime | Data e horário solicitados para o atendimento |
| tipoServico | TipoServico | Tipo de serviço solicitado |
| descricao | String? | Descrição adicional da solicitação |
| status | StatusAgendamento | Status atual do agendamento |
| createdAt | DateTime | Data de criação do registro |
| updatedAt | DateTime | Data da última atualização |

## Enums

### StatusAgendamento

Define os possíveis estados de uma solicitação de agendamento.

| Valor | Descrição |
|---|---|
| PENDENTE | Solicitação criada e aguardando resposta do estilista |
| ACEITO | Solicitação aceita pelo estilista |
| RECUSADO | Solicitação recusada pelo estilista |
| CANCELADO | Solicitação cancelada |
| CONCLUIDO | Atendimento concluído |

### TipoServico

Define os tipos de serviço disponíveis na plataforma.

| Valor | Descrição |
|---|---|
| CONSULTORIA_ESTILO | Consultoria de estilo |
| MONTAGEM_LOOK | Montagem de looks |
| ROUPA_SOB_MEDIDA | Criação de roupa ou peça personalizada |
| ACOMPANHAMENTO_EVENTO | Acompanhamento para evento |
| OUTRO | Outro tipo de serviço |

## Relacionamentos

- Um cliente pode possuir vários agendamentos.
- Um estilista pode receber vários agendamentos.
- Um agendamento pertence a um cliente.
- Um agendamento pertence a um estilista.
