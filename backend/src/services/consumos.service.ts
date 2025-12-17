import { prisma } from '../db/prismaClient.js';

export async function crearConsumo(
  centralId: number,
  fecha: Date,
  valorGJ: number,
) {
  return prisma.consumos.create({
    data: { centralId, fecha, valorGJ },
  });
}

export async function listarConsumos() {
  return prisma.consumos.findMany({ include: { centrales: true } });
}
