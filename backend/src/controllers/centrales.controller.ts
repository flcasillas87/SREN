import { Request, Response } from 'express';
import * as centralesService from '../services/centrales.service.js';

export const agregarCentral = (_: Request, res: Response) => {
  res.json({ message: 'Agregar Central' });
};

export async function obtenerCentrales(req: Request, res: Response) {
  try {
    const centrales = await centralesService.listarCentrales();
    res.json(centrales);
  } catch (error) {
    console.error('Error obteniendo centrales:', error);
    res.status(500).json({ error: 'Error al obtener centrales' });
  }
}
