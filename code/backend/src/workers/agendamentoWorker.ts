import { AgendamentoMessagingService } from '../services/messaging/agendamentoMessagingService.js';
import { AgendamentoService } from '../modules/agendamentos/agendamentoService.js';
import { StatusAgendamento } from '../generated/prisma/client.js';
import type { AgendamentoPrioridadeMessage } from '../services/messaging/agendamentoMessagingService.js';

export class AgendamentoWorker {
  private messagingService: AgendamentoMessagingService;
  private agendamentoService: AgendamentoService;

  constructor() {
    this.messagingService = new AgendamentoMessagingService();
    this.agendamentoService = new AgendamentoService();
  }

  async iniciar(): Promise<void> {
    console.log('Worker de agendamentos iniciado');

    await this.messagingService.consumirFilaPrioridade(async (data) => {
      try {
        await this.processarAgendamentoPrioritario(data);
      } catch (error) {
        console.error(`Erro ao processar agendamento prioritário ${data.agendamentoId}:`, error);
        throw error;
      }
    });

    await this.messagingService.consumirFilaStatus(async (data) => {
      try {
        console.log(`Status do agendamento ${data.agendamentoId} atualizado para: ${data.status}`);
        
      } catch (error) {
        console.error(`Erro ao processar status do agendamento ${data.agendamentoId}:`, error);
        throw error;
      }
    });

    console.log('Workers configurados e ouvindo filas');
  }

  private async processarAgendamentoPrioritario(
    data: AgendamentoPrioridadeMessage
  ): Promise<void> {
    console.log(`Verificando conflitos para agendamento ${data.agendamentoId}`);

    try {
      const agendamentosEstilista = await this.agendamentoService.listarPorEstilista(
        data.estilistaId
      );

      const dataAgendamento = new Date(data.data);
      const conflito = agendamentosEstilista.find(agendamento => {
        const agendamentoData = new Date(agendamento.data);
        return (
          agendamentoData.getTime() === dataAgendamento.getTime() &&
          agendamento.status === StatusAgendamento.ACEITO &&
          agendamento.id !== data.agendamentoId
        );
      });

      if (conflito) {
        await this.resolverConflito(data, conflito);
      }

    } catch (error) {
      console.error(`Erro ao processar agendamento ${data.agendamentoId}:`, error);
      throw error;
    }
  }

  private async resolverConflito(
    novoAgendamento: AgendamentoPrioridadeMessage,
    agendamentoExistente: any
  ): Promise<void> {
    console.log(`Conflito detectado: Agendamento ${novoAgendamento.agendamentoId} vs ${agendamentoExistente.id}`);

    const dataCriacaoNovo = new Date(novoAgendamento.createdAt);
    const dataCriacaoExistente = new Date(agendamentoExistente.createdAt);

    if (dataCriacaoNovo < dataCriacaoExistente) {
      await this.agendamentoService.atualizarStatus(
        agendamentoExistente.id,
        { status: StatusAgendamento.CANCELADO }
      );

      await this.agendamentoService.atualizarStatus(
        novoAgendamento.agendamentoId,
        { status: StatusAgendamento.ACEITO }
      );

      console.log(`Agendamento ${novoAgendamento.agendamentoId} aceito (mais antigo). Agendamento ${agendamentoExistente.id} cancelado.`);
    } else {
      await this.agendamentoService.atualizarStatus(
        novoAgendamento.agendamentoId,
        { status: StatusAgendamento.RECUSADO }
      );

      console.log(`Agendamento ${novoAgendamento.agendamentoId} recusado. Horário já ocupado por agendamento mais antigo #${agendamentoExistente.id}`);
    }
  }
}