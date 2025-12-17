// src/middlewares/errorHandler.ts
import { Request, Response } from 'express';

export default function errorHandler(err: Error, req: Request, res: Response) {
  console.error(err);
  res.status(500).json({ error: 'Error interno del servidor' });
}
