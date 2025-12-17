import { Request, Response } from 'express';

export const getHome = (_: Request, res: Response) => {
  res.json({ message: 'HOME funcionando 🚀' });
};
