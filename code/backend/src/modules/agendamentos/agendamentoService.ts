import { AgendamentoRepository } from "./agendamentoRepository.js";
import { ClienteRepository } from "../clientes/clienteRepository.js";
import { EstilistaRepository } from "../estilistas/estilistaRepository.js";
import { StatusAgendamento, TipoServico } from "../../generated/prisma/client.js";


interface CriarAgendamentoInput {
  clienteId: number;
  estilistaId: number;
  data: string;
  tipoServico: TipoServico;
  descricao?: string;
}

interface AtualizarStatusInput {
  status: StatusAgendamento;
}

const statusPermitidos: StatusAgendamento[] = [
  "PENDENTE",
  "ACEITO",
  "RECUSADO",
  "CANCELADO",
  "CONCLUIDO",
];

const tiposServicoPermitidos: TipoServico[] = [
  "CONSULTORIA_ESTILO",
  "MONTAGEM_LOOK",
  "ROUPA_SOB_MEDIDA",
  "ACOMPANHAMENTO_EVENTO",
  "OUTRO",
];

export class AgendamentoService {
  private agendamentoRepository: AgendamentoRepository;
  private clienteRepository: ClienteRepository;
  private estilistaRepository: EstilistaRepository;

  constructor() {
    this.agendamentoRepository = new AgendamentoRepository();
    this.clienteRepository = new ClienteRepository();
    this.estilistaRepository = new EstilistaRepository();
  }

  async criar(data: CriarAgendamentoInput) {
    const cliente = await this.clienteRepository.buscarPorId(data.clienteId);

    if (!cliente) {
      throw new Error("Cliente não encontrado.");
    }

    const estilista = await this.estilistaRepository.buscarPorId(
      data.estilistaId
    );

    if (!estilista) {
      throw new Error("Estilista não encontrado.");
    }

    if (!tiposServicoPermitidos.includes(data.tipoServico)) {
      throw new Error("Tipo de serviço inválido.");
    }

    const dataAgendamento = new Date(data.data);

    if (Number.isNaN(dataAgendamento.getTime())) {
      throw new Error("Data do agendamento inválida.");
    }

    return this.agendamentoRepository.criar({
      clienteId: data.clienteId,
      estilistaId: data.estilistaId,
      data: dataAgendamento,
      tipoServico: data.tipoServico,
      ...(data.descricao !== undefined && { descricao: data.descricao }),
    });
  }

  async listarTodos() {
    return this.agendamentoRepository.listarTodos();
  }

  async buscarPorId(id: number) {
    const agendamento = await this.agendamentoRepository.buscarPorId(id);

    if (!agendamento) {
      throw new Error("Agendamento não encontrado.");
    }

    return agendamento;
  }

  async listarPorCliente(clienteId: number) {
    const cliente = await this.clienteRepository.buscarPorId(clienteId);

    if (!cliente) {
      throw new Error("Cliente não encontrado.");
    }

    return this.agendamentoRepository.listarPorCliente(clienteId);
  }

  async listarPorEstilista(estilistaId: number) {
    const estilista = await this.estilistaRepository.buscarPorId(estilistaId);

    if (!estilista) {
      throw new Error("Estilista não encontrado.");
    }

    return this.agendamentoRepository.listarPorEstilista(estilistaId);
  }

  async atualizarStatus(id: number, data: AtualizarStatusInput) {
    await this.buscarPorId(id);

    if (!statusPermitidos.includes(data.status)) {
      throw new Error("Status inválido.");
    }

    return this.agendamentoRepository.atualizarStatus(id, {
      status: data.status,
    });
  }

  async deletar(id: number) {
    await this.buscarPorId(id);

    return this.agendamentoRepository.deletar(id);
  }
}