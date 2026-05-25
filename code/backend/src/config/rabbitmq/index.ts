import amqp from "amqplib";
import type { Channel, ChannelModel } from "amqplib";
import { env } from "../../env.js";

class RabbitMQConfig {
  private static instance: RabbitMQConfig;
  private connection: ChannelModel | null = null;
  private channel: Channel | null = null;
  private readonly url: string;
  private isConnected: boolean = false;

  private constructor() {
    this.url = env.RABBITMQ_URL || "amqp://localhost:5672";
  }

  static getInstance(): RabbitMQConfig {
    if (!RabbitMQConfig.instance) {
      RabbitMQConfig.instance = new RabbitMQConfig();
    }
    return RabbitMQConfig.instance;
  }

  async connect(): Promise<void> {
    try {
      this.connection = await amqp.connect(this.url);
      this.channel = await this.connection.createChannel();

      this.isConnected = true;
      console.log("Conectado ao RabbitMQ");

      await this.setupQueuesAndExchanges();
    } catch (error) {
      console.error("Erro ao conectar ao RabbitMQ:", error);
      this.isConnected = false;
      throw error;
    }
  }

  private async setupQueuesAndExchanges(): Promise<void> {
    if (!this.channel) throw new Error("Channel not initialized");

    await this.channel.assertQueue("agendamento.status", {
      durable: true,
    });

    await this.channel.assertQueue("agendamento.prioridade", {
      durable: true,
      maxPriority: 10,
    });

    console.log("Filas configuradas");
  }

  getChannel(): Channel {
    if (!this.channel || !this.isConnected) {
      throw new Error("RabbitMQ channel not initialized or not connected");
    }
    return this.channel;
  }

  async close(): Promise<void> {
    try {
      if (this.channel) {
        await this.channel.close();
      }
      if (this.connection) {
        await this.connection.close();
      }
      this.isConnected = false;
      console.log("🔌 Conexão com RabbitMQ fechada");
    } catch (error) {
      console.error("Erro ao fechar conexão RabbitMQ:", error);
    }
  }

  getConnectionStatus(): boolean {
    return this.isConnected;
  }
}

export const rabbitMQConfig = RabbitMQConfig.getInstance();