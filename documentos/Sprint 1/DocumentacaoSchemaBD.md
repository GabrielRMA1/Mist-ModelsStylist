# Schema do Banco de Dados

O banco de dados do projeto utiliza PostgreSQL e foi modelado com Prisma ORM.

Atualmente o sistema possui quatro entidades principais:

* User
* Cliente
* Estilista
* Agendamento

Além disso, o banco utiliza enums para controle de permissões e status dos agendamentos.

---

# User

Representa a entidade principal de autenticação do sistema.

Todos os usuários possuem credenciais de acesso e um papel definido dentro da plataforma.

| Campo     | Tipo     | Descrição                         |
| --------- | -------- | --------------------------------- |
| id        | Int      | Identificador único do usuário    |
| email     | String   | E-mail único utilizado para login |
| senha     | String   | Senha criptografada do usuário    |
| role      | UserRole | Papel do usuário no sistema       |
| createdAt | DateTime | Data de criação do registro       |
| updatedAt | DateTime | Data da última atualização        |

---

# Cliente

Representa o usuário final que solicita atendimentos com estilistas.

| Campo     | Tipo     | Descrição                             |
| --------- | -------- | ------------------------------------- |
| id        | Int      | Identificador único do cliente        |
| nome      | String   | Nome do cliente                       |
| telefone  | String?  | Telefone de contato do cliente        |
| userId    | Int      | Referência para o usuário autenticado |
| createdAt | DateTime | Data de criação do registro           |
| updatedAt | DateTime | Data da última atualização            |

---

# Estilista

Representa o prestador de serviço que recebe e responde às solicitações de agendamento.

| Campo         | Tipo     | Descrição                             |
| ------------- | -------- | ------------------------------------- |
| id            | Int      | Identificador único do estilista      |
| nome          | String   | Nome do estilista                     |
| telefone      | String?  | Telefone de contato do estilista      |
| especialidade | String   | Área de atuação do estilista          |
| descricao     | String?  | Descrição profissional do estilista   |
| userId        | Int      | Referência para o usuário autenticado |
| createdAt     | DateTime | Data de criação do registro           |
| updatedAt     | DateTime | Data da última atualização            |

---

# Agendamento

Representa a solicitação feita por um cliente para um estilista.

| Campo       | Tipo              | Descrição                                     |
| ----------- | ----------------- | --------------------------------------------- |
| id          | Int               | Identificador único do agendamento            |
| clienteId   | Int               | Identificador do cliente solicitante          |
| estilistaId | Int               | Identificador do estilista solicitado         |
| data        | DateTime          | Data e horário solicitados para o atendimento |
| tipoServico | TipoServico       | Tipo de serviço solicitado                    |
| descricao   | String?           | Descrição adicional da solicitação            |
| status      | StatusAgendamento | Status atual do agendamento                   |
| createdAt   | DateTime          | Data de criação do registro                   |
| updatedAt   | DateTime          | Data da última atualização                    |

---

# Enums

## UserRole

Define os tipos de usuários disponíveis no sistema.

| Valor     | Descrição                             |
| --------- | ------------------------------------- |
| CLIENTE   | Usuário que solicita atendimentos     |
| ESTILISTA | Usuário que presta serviços de estilo |

---

## StatusAgendamento

Define os possíveis estados de uma solicitação de agendamento.

| Valor     | Descrição                                             |
| --------- | ----------------------------------------------------- |
| PENDENTE  | Solicitação criada e aguardando resposta do estilista |
| ACEITO    | Solicitação aceita pelo estilista                     |
| RECUSADO  | Solicitação recusada pelo estilista                   |
| CANCELADO | Solicitação cancelada                                 |
| CONCLUIDO | Atendimento concluído                                 |

---

## TipoServico

Define os tipos de serviço disponíveis na plataforma.

| Valor                 | Descrição                      |
| --------------------- | ------------------------------ |
| CONSULTORIA_ESTILO    | Consultoria de estilo          |
| MONTAGEM_LOOK         | Montagem de looks              |
| ROUPA_SOB_MEDIDA      | Criação de roupa personalizada |
| ACOMPANHAMENTO_EVENTO | Acompanhamento para eventos    |
| OUTRO                 | Outro tipo de serviço          |

---

# Relacionamentos Gerais

* Um usuário pode possuir um perfil de cliente.
* Um usuário pode possuir um perfil de estilista.
* Um cliente pertence a um usuário.
* Um estilista pertence a um usuário.
* Um cliente pode possuir vários agendamentos.
* Um estilista pode receber vários agendamentos.
* Um agendamento pertence a um cliente.
* Um agendamento pertence a um estilista.
