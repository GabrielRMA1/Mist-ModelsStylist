/*
  Warnings:

  - You are about to drop the column `email` on the `Cliente` table. All the data in the column will be lost.
  - You are about to drop the column `email` on the `Estilista` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[userId]` on the table `Cliente` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userId]` on the table `Estilista` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `userId` to the `Cliente` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userId` to the `Estilista` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('CLIENTE', 'ESTILISTA');

-- DropIndex
DROP INDEX "Cliente_email_key";

-- DropIndex
DROP INDEX "Estilista_email_key";

-- AlterTable
ALTER TABLE "Cliente" DROP COLUMN "email",
ADD COLUMN     "userId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "Estilista" DROP COLUMN "email",
ADD COLUMN     "userId" INTEGER NOT NULL;

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "senha" TEXT NOT NULL,
    "role" "UserRole" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Cliente_userId_key" ON "Cliente"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Estilista_userId_key" ON "Estilista"("userId");

-- AddForeignKey
ALTER TABLE "Cliente" ADD CONSTRAINT "Cliente_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Estilista" ADD CONSTRAINT "Estilista_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
