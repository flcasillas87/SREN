import { Router } from 'express';
import { getAbout } from '../controllers/abouth.controller.js';

const router = Router();

router.get('/', getAbout);

export default router;
