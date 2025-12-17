import { Router } from 'express';
import * as centralesController from '../controllers/centrales.controller.js';

const router = Router();

router.get('/', centralesController.obtenerCentrales);

export default router;
