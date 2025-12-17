import fs from 'fs/promises';
import path from 'path';

const dataFilePath = path.resolve('data.json'); // Ruta del archivo JSON local

// Verifica si el archivo existe y si no, lo crea con datos iniciales
export async function ensureDataFileExists(
  initialData: any = [],
): Promise<void> {
  try {
    await fs.access(dataFilePath);
    // Si no hay error, el archivo existe
  } catch {
    // Archivo no existe, crearlo con datos iniciales (array vacío por defecto)
    await saveData(initialData);
  }
}

// Leer datos del archivo JSON
export async function loadData(): Promise<any> {
  try {
    const data = await fs.readFile(dataFilePath, 'utf-8');
    return JSON.parse(data);
  } catch (error) {
    console.error('Error al leer data.json:', error);
    throw error;
  }
}

// Guardar datos en el archivo JSON
export async function saveData(data: any): Promise<void> {
  try {
    const json = JSON.stringify(data, null, 2);
    await fs.writeFile(dataFilePath, json, 'utf-8');
  } catch (error) {
    console.error('Error al guardar data.json:', error);
    throw error;
  }
}

// Función para agregar un registro a los datos existentes y guardarlos
export async function addRecord(record: any): Promise<void> {
  const data = await loadData();
  data.push(record);
  await saveData(data);
}

// Función para eliminar un registro por id (suponiendo que cada registro tiene id)
export async function deleteRecordById(id: string | number): Promise<void> {
  const data = await loadData();
  const filteredData = data.filter((item: any) => item.id !== id);
  await saveData(filteredData);
}

// Función para sincronizar datos guardados localmente con base de datos
export async function syncWithDatabase(
  syncFn: (data: any) => Promise<void>,
): Promise<void> {
  const data = await loadData();
  try {
    await syncFn(data);
    // Una vez sincronizado con éxito, puedes limpiar el archivo local
    await saveData([]);
  } catch (error) {
    console.error('Error sincronizando con DB:', error);
  }
}
