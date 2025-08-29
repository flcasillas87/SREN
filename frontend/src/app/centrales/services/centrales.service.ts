import { Injectable, signal } from '@angular/core';
import { Central } from '../models/central.model';
@Injectable({ providedIn: 'root' })
export class CentralesService {
  // Señal reactiva que contiene las centrales
  readonly centrales = signal<Central[]>([]);
  variable = 'Hola mundo';
  texto = 'Servicio de Centrales';

  loadCentrales() {
    const mockData: Central[] = [
      {
        central_id: 1,
        nombre: 'Central A',
        ubicacion_estado: 'Estado 1',
        tipo_central: 'Tipo 1',
        estado_operacion: 'Operativa',
      },
      {
        central_id: 2,
        nombre: 'Central B',
        ubicacion_estado: 'Estado 2',
        tipo_central: 'Tipo 2',
        estado_operacion: 'En mantenimiento',
      },
      {
        central_id: 3,
        nombre: 'Central C',
        ubicacion_estado: 'Estado 3',
        tipo_central: 'Tipo 3',
        estado_operacion: 'Operativa',
      },
    ];
    this.setCentrales(mockData);
  }

  setCentrales(lista: Central[]) {
  this.centrales.set(lista);
}

}
