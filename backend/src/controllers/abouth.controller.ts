import { Request, Response } from 'express';
import { getAboutInfo } from '../services/abouth.service.js';

export const getAbout = (_: Request, res: Response) => {
  const info = getAboutInfo();
  res.json(info);
};
