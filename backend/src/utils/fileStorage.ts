//Para leer/escribir JSON local
import fs from 'fs/promises';
import path from 'path';

const dataFilePath = path.resolve('./data/pendingUsers.json');

export async function saveUserLocally(user: any) {
  let data: any[] = [];
  try {
    const file = await fs.readFile(dataFilePath, 'utf8');
    data = JSON.parse(file);
  } catch {
    // Si no existe el archivo, empieza con array vacío
  }
  data.push(user);
  await fs.mkdir(path.dirname(dataFilePath), { recursive: true });
  await fs.writeFile(dataFilePath, JSON.stringify(data, null, 2));
}

export async function getPendingUsers() {
  try {
    const file = await fs.readFile(dataFilePath, 'utf8');
    return JSON.parse(file);
  } catch {
    return [];
  }
}

export async function clearPendingUsers() {
  await fs.writeFile(dataFilePath, JSON.stringify([], null, 2));
}
