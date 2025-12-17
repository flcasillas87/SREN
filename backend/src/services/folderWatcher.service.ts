import chokidar from 'chokidar';
import path from 'path';
import { fileURLToPath } from 'url'; // 👈 Nuevas importaciones

// Obtén __dirname en ES Modules
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// El resto del código sigue igual
const WATCH_FOLDER = path.join(__dirname, 'mi_carpeta');
const watcher = chokidar.watch(WATCH_FOLDER, {
  ignored: /(^|[\/\\])\../,
  persistent: true,
});

watcher
  .on('add', (filePath) =>
    console.log(`📄 Archivo añadido: ${path.basename(filePath)}`),
  )
  .on('change', (filePath) =>
    console.log(`✏️ Archivo modificado: ${path.basename(filePath)}`),
  )
  .on('unlink', (filePath) =>
    console.log(`❌ Archivo eliminado: ${path.basename(filePath)}`),
  )
  .on('error', (error) => console.error(`🔥 Error: ${error}`));

console.log(`👀 Vigilando la carpeta: ${WATCH_FOLDER}`);
