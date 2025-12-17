import { Application } from 'express';

import centralesRoutes from './centrales.routes.js';
import authRoutes from './auth.routes.js';
import userRoutes from './users.routes.js';
import consumoRoutes from './consumos.routes.js';
import aboutRoutes from './abouth.routes.js';
import { getHome } from '../controllers/home.controller.js';
import notFoundHandler from '../middlewares/notFoundHandler.js';
import errorHandler from '../middlewares/errorHandler.js';

export function registerRoutes(app: Application): void {
  app.get('/', getHome);

  app.use('/about', aboutRoutes);
  app.use('/auth', authRoutes);
  app.use('/users', userRoutes);
  app.use('/consumos', consumoRoutes);
  app.use('/centrales', centralesRoutes);

  app.use(notFoundHandler);
  app.use(errorHandler);
}
