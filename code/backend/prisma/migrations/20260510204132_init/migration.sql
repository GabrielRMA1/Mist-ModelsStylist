-- CreateEnum
CREATE TYPE "StatusAgendamento" AS ENUM ('PENDENTE', 'ACEITO', 'RECUSADO', 'CANCELADO', 'CONCLUIDO');

-- CreateEnum
CREATE TYPE "TipoServico" AS ENUM ('CONSULTORIA_ESTILO', 'MONTAGEM_LOOK', 'ROUPA_SOB_MEDIDA', 'ACOMPANHAMENTO_EVENTO', 'OUTRO');

-- CreateTable
CREATE TABLE "Cliente" (
    "id" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "telefone" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Cliente_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Estilista" (
    "id" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "telefone" TEXT,
    "especialidade" TEXT NOT NULL,
    "descricao" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Estilista_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Agendamento" (
    "id" SERIAL NOT NULL,
    "clienteId" INTEGER NOT NULL,
    "estilistaId" INTEGER NOT NULL,
    "data" TIMESTAMP(3) NOT NULL,
    "tipoServico" "TipoServico" NOT NULL,
    "descricao" TEXT,
    "status" "StatusAgendamento" NOT NULL DEFAULT 'PENDENTE',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Agendamento_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Cliente_email_key" ON "Cliente"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Estilista_email_key" ON "Estilista"("email");

-- AddForeignKey
ALTER TABLE "Agendamento" ADD CONSTRAINT "Agendamento_clienteId_fkey" FOREIGN KEY ("clienteId") REFERENCES "Cliente"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Agendamento" ADD CONSTRAINT "Agendamento_estilistaId_fkey" FOREIGN KEY ("estilistaId") REFERENCES "Estilista"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
