// Para sincronización JSON -> DB
import { PrismaClient } from '@prisma/client';
import { getPendingUsers, clearPendingUsers } from '../utils/fileStorage.js';

const prisma = new PrismaClient();

export async function syncPendingUsers() {}
