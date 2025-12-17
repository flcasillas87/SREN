import { Request, Response } from 'express';
import * as consumoService from '../services/consumos.service.js';

export async function agregarConsumo(req: Request, res: Response) {
  try {
    const { centralId, fecha, valorGJ } = req.body;
    const consumos = await consumoService.crearConsumo(
      centralId,
      new Date(fecha),
      valorGJ,
    );
    res.status(201).json(consumos);
  } catch (error) {
    res.status(500).json({ error: 'Error creando consumo' });
  }
}

export async function getConsumos(req: Request, res: Response) {
  const consumos = await consumoService.listarConsumos();
  res.json(consumos);
}
