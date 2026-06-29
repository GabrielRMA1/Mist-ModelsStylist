import { AgendamentoMessagingService } from '../services/messaging/agendamentoMessagingService.js';
import type { AgendamentoPrioridadeMessage } from '../services/messaging/agendamentoMessagingService.js';

export class AgendamentoWorker {
  private messagingService: AgendamentoMessagingService;

  constructor() {
    this.messagingService = new AgendamentoMessagingService();
  }

  async iniciar(): Promise<void> {
    console.log('Worker de agendamentos iniciado');

    await this.messagingService.consumirFilaPrioridade(async (data) => {
      this.processarAgendamentoPrioritario(data);
    });

    await this.messagingService.consumirFilaStatus(async (data) => {
      console.log(
        `Status do agendamento ${data.agendamentoId} publicado: ${data.status}`,
      );
    });

    console.log('Workers configurados e ouvindo filas');
  }

  private processarAgendamentoPrioritario(
    data: AgendamentoPrioridadeMessage,
  ): void {
    console.log(
      `Nova solicitacao recebida na fila: agendamento ${data.agendamentoId} para estilista ${data.estilistaId}`,
    );
  }
}
