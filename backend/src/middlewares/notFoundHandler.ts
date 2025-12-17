// src/middlewares/notFoundHandler.ts
import { Request, Response } from 'express';

export default function notFoundHandler(req: Request, res: Response) {
  res.status(404).json({ error: 'Ruta no encontrada amguito' });
}
