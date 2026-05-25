import { Channel } from 'amqplib';
import { rabbitMQConfig } from '../../config/rabbitmq/index.js';
import { StatusAgendamento, TipoServico } from '../../generated/prisma/client.js';

export interface AgendamentoStatusMessage {
  agendamentoId: number;
  status: StatusAgendamento;
  timestamp: Date;
  metadata?: Record<string, any>;
}

export interface AgendamentoPrioridadeMessage {
  agendamentoId: number;
  clienteId: number;
  estilistaId: number;
  data: Date;
  tipoServico: TipoServico;
  prioridade: number;
  createdAt: Date;
}

export interface NotificacaoMessage {
  tipo: string;
  dados: any;
  timestamp: Date;
  canal?: 'email' | 'sistema';
}

export class AgendamentoMessagingService {
  private channel: Channel;

  constructor() {
    this.channel = rabbitMQConfig.getChannel();
  }


  async publicarAtualizacaoStatus(data: AgendamentoStatusMessage): Promise<void> {
    try {
      const message = Buffer.from(JSON.stringify(data));
      
      this.channel.sendToQueue('agendamento.status', message, {
        persistent: true,
        messageId: `status-${data.agendamentoId}-${Date.now()}`,
        timestamp: Date.now(),
        headers: {
          'x-retry-count': 0
        }
      });

      console.log(`Status publicado: Agendamento ${data.agendamentoId} -> ${data.status}`);
    } catch (error) {
      console.error('Erro ao publicar atualização de status:', error);
      throw error;
    }
  }

 
  async publicarAgendamentoPrioritario(data: AgendamentoPrioridadeMessage): Promise<void> {
    try {
      const prioridadeCalculada = this.calcularPrioridade(data.createdAt);
      
      const mensagem: AgendamentoPrioridadeMessage = {
        ...data,
        prioridade: prioridadeCalculada
      };

      const message = Buffer.from(JSON.stringify(mensagem));
      
      this.channel.sendToQueue('agendamento.prioridade', message, {
        persistent: true,
        priority: prioridadeCalculada,
        messageId: `prioridade-${data.agendamentoId}-${Date.now()}`,
        timestamp: Date.now()
      });

      console.log(`Agendamento ${data.agendamentoId} publicado com prioridade ${prioridadeCalculada}`);
    } catch (error) {
      console.error('Erro ao publicar agendamento prioritário:', error);
      throw error;
    }
  }

  
  async consumirFilaStatus(
    callback: (data: AgendamentoStatusMessage) => Promise<void>
  ): Promise<void> {
    await this.channel.prefetch(1);
    
    await this.channel.consume('agendamento.status', async (msg) => {
      if (!msg) return;

      try {
        const data: AgendamentoStatusMessage = JSON.parse(msg.content.toString());
        console.log(`Processando status: Agendamento ${data.agendamentoId}`);
        
        await callback(data);
        
        this.channel.ack(msg);
        console.log(`Status processado: Agendamento ${data.agendamentoId}`);
      } catch (error) {
        console.error(`Erro ao processar status:`, error);
        
      
        const retryCount = (msg.properties.headers?.['x-retry-count'] || 0) + 1;
        
        if (retryCount <= 3) {

          const delay = Math.pow(2, retryCount) * 1000;
          setTimeout(() => {
            this.channel.nack(msg, false, true);
          }, delay);
          
          console.log(`Retry ${retryCount}/3 para agendamento em ${delay}ms`);
        } else {

          this.channel.nack(msg, false, false);
          console.log(`Mensagem enviada para DLQ após ${retryCount} tentativas`);
        }
      }
    });
  }

  async consumirFilaPrioridade(
    callback: (data: AgendamentoPrioridadeMessage) => Promise<void>
  ): Promise<void> {
    await this.channel.prefetch(1);
    
    await this.channel.consume('agendamento.prioridade', async (msg) => {
      if (!msg) return;

      try {
        const data: AgendamentoPrioridadeMessage = JSON.parse(msg.content.toString());
        console.log(`Processando prioridade: Agendamento ${data.agendamentoId} (P${data.prioridade})`);
        
        await callback(data);
        
        this.channel.ack(msg);
        console.log(`Prioridade processada: Agendamento ${data.agendamentoId}`);
      } catch (error) {
        console.error(`Erro ao processar prioridade:`, error);
        
        this.channel.nack(msg, false, true);
      }
    });
  }

  
  async publicarNotificacao(
    tipo: string,
    dados: any,
    canal: 'email' | 'sistema' = 'sistema'
  ): Promise<void> {
    try {
      const mensagem: NotificacaoMessage = {
        tipo,
        dados,
        timestamp: new Date(),
        canal
      };

      const message = Buffer.from(JSON.stringify(mensagem));
      const routingKey = `${canal}.${tipo.toLowerCase()}`;
      
      this.channel.publish('notificacoes', routingKey, message, {
        persistent: true,
        messageId: `notif-${Date.now()}`
      });

      console.log(`Notificação publicada: ${tipo} (${canal})`);
    } catch (error) {
      console.error('Erro ao publicar notificação:', error);
      throw error;
    }
  }


  private calcularPrioridade(dataCriacao: Date): number {
    const agora = new Date();
    const diferencaHoras = (agora.getTime() - new Date(dataCriacao).getTime()) / (1000 * 60 * 60);
    
    if (diferencaHoras >= 48) return 10;
    if (diferencaHoras >= 24) return 9;
    if (diferencaHoras >= 12) return 8;
    if (diferencaHoras >= 6) return 7;
    if (diferencaHoras >= 3) return 6;
    if (diferencaHoras >= 1) return 5;
    if (diferencaHoras >= 0.5) return 3;
    return 1;
  }
}