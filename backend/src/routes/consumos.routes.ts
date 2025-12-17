import { Router } from 'express';
import * as consumoController from '../controllers/consumos.controller.js';

const router = Router();

router.post('/consumos', consumoController.agregarConsumo);
router.get('/consumos', consumoController.getConsumos);

export default router;
