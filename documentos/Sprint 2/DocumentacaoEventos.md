# Documentação dos Eventos

O sistema utiliza RabbitMQ para comunicação assíncrona entre controllers e workers. Atualmente existem dois eventos principais relacionados aos agendamentos.

---

# Evento 1 — Criação de Agendamento

Esse evento acontece após a criação de um novo agendamento pela rota `POST /agendamentos`.

| Campo          | Descrição                                         |
| -------------- | ------------------------------------------------- |
| Nome do evento | `agendamento.criado`                              |
| Produtor       | `AgendamentoController.criar()`                   |
| Consumidor     | `AgendamentoWorker`                               |
| Fila utilizada | `agendamento.prioridade`                          |
| Objetivo       | Verificar conflitos de horário entre agendamentos |

## Exemplo de Payload

```json
{
  "agendamentoId": 15,
  "clienteId": 3,
  "estilistaId": 2,
  "data": "2026-05-25T14:00:00.000Z",
  "tipoServico": "CONSULTORIA_ESTILO",
  "prioridade": 8,
  "createdAt": "2026-05-23T10:30:00.000Z"
}
```

## Funcionamento

Após salvar o agendamento no banco de dados, o sistema publica uma mensagem na fila `agendamento.prioridade`.

O worker consome essa mensagem e verifica possíveis conflitos de horário entre agendamentos do mesmo estilista. Quanto mais antigo o agendamento, maior sua prioridade na fila.

---

# Evento 2 — Atualização de Status

Esse evento acontece após a atualização de status de um agendamento pela rota `PATCH /agendamentos/:id/status`.

| Campo          | Descrição                                       |
| -------------- | ----------------------------------------------- |
| Nome do evento | `agendamento.status.atualizado`                 |
| Produtor       | `AgendamentoController.atualizarStatus()`       |
| Consumidor     | `AgendamentoWorker`                             |
| Fila utilizada | `agendamento.status`                            |
| Objetivo       | Registrar alterações de status dos agendamentos |

## Exemplo de Payload

```json
{
  "agendamentoId": 15,
  "status": "ACEITO",
  "timestamp": "2026-05-24T14:30:00.000Z"
}
```

## Status possíveis

| Status    | Descrição                        |
| --------- | -------------------------------- |
| PENDENTE  | Aguardando resposta do estilista |
| ACEITO    | Agendamento aceito               |
| RECUSADO  | Agendamento recusado             |
| CANCELADO | Agendamento cancelado            |
| CONCLUIDO | Atendimento finalizado           |

## Funcionamento

Após a atualização do status, o sistema envia uma mensagem para a fila `agendamento.status`.

Atualmente o worker utiliza esse evento para processamento interno, mas ele também pode ser utilizado futuramente para notificações, envio de e-mails e geração de logs.

---

# Fluxo Geral dos Eventos

## Criação de Agendamento

```text
POST /agendamentos
    ↓
Controller salva no banco
    ↓
Evento enviado para RabbitMQ
    ↓
Fila agendamento.prioridade
    ↓
Worker consome a mensagem
    ↓
Sistema verifica conflitos
```

---

## Atualização de Status

```text
PATCH /agendamentos/:id/status
    ↓
Controller atualiza status
    ↓
Evento enviado para RabbitMQ
    ↓
Fila agendamento.status
    ↓
Worker consome a mensagem
```
