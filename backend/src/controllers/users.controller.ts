import { Request, Response } from 'express';

export const getUsers = (_: Request, res: Response) => {
  res.json({ message: 'Lista de usuarios no implementada aún' });
};
