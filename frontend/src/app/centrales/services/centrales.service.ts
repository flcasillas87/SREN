import { computed, effect,Injectable, signal } from '@angular/core';

import { Central } from '../models/central.model';

/**
 * ==============================
 * CENTRALES SERVICE - TRON PRO ULTRA
 * ==============================
 * 
 * Servicio centralizado para gestión de centrales eléctricas usando señales de Angular.
 * Totalmente reactivo con:
 * - Signals privadas y públicas
 * - Computed para métricas y estadísticas
 * - Efectos para inicialización y logging
 * - CRUD asíncrono con manejo de carga y errores
 * - Filtros dinámicos y memoizados
 */

@Injectable({ providedIn: 'root' })
export class CentralesService {

  // ==============================
  // 1️⃣ Señales privadas (estado interno)
  // ==============================
  private readonly _centrales = signal<Central[]>([]);       // Almacena todas las centrales
  private readonly _loading = signal<boolean>(false);        // Indica si hay operación de carga en progreso
  private readonly _error = signal<string | null>(null);     // Mensaje de error del servicio
  private readonly _ultimaActualizacion = signal<Date | null>(null); // Fecha de última actualización real

  // ==============================
  // 2️⃣ Señales públicas (solo lectura)
  // ==============================
  readonly centrales = this._centrales.asReadonly();       // Lista de centrales expuesta a componentes
  readonly loading = this._loading.asReadonly();           // Estado de carga expuesto
  readonly error = this._error.asReadonly();               // Mensaje de error expuesto
  readonly ultimaActualizacion = this._ultimaActualizacion.asReadonly(); // Timestamp expuesto

  // ==============================
  // 3️⃣ Computed / métricas derivadas
  // ==============================
  readonly centralesOperativas = computed(() =>
    this.centrales().filter(c => c.estado_operacion === 'Operativa')
  ); // Filtra centrales con estado 'Operativa'

  readonly centralesEnMantenimiento = computed(() =>
    this.centrales().filter(c => c.estado_operacion === 'En mantenimiento')
  ); // Filtra centrales con estado 'En mantenimiento'

  readonly totalCentrales = computed(() => this.centrales().length); // Total de centrales

  readonly centralesPorEstado = computed<Record<Central['ubicacion_estado'], number>>(() =>
    this.centrales().reduce((acc, c) => {
      acc[c.ubicacion_estado] = (acc[c.ubicacion_estado] || 0) + 1;
      return acc;
    }, {} as Record<Central['ubicacion_estado'], number>)
  ); // Conteo de centrales por estado

  readonly centralesPorTipo = computed<Record<Central['tipo_central'], number>>(() =>
    this.centrales().reduce((acc, c) => {
      acc[c.tipo_central] = (acc[c.tipo_central] || 0) + 1;
      return acc;
    }, {} as Record<Central['tipo_central'], number>)
  ); // Conteo de centrales por tipo

  readonly estadisticas = computed(() => ({
    total: this.totalCentrales(),
    operativas: this.centralesOperativas().length,
    enMantenimiento: this.centralesEnMantenimiento().length,
    porcentajeOperativo: this.totalCentrales() > 0 ? (this.centralesOperativas().length / this.totalCentrales()) * 100 : 0,
    porEstado: this.centralesPorEstado(),
    porTipo: this.centralesPorTipo(),
    ultimaActualizacion: this._ultimaActualizacion() ? this._ultimaActualizacion()!.toISOString() : null
  })); // Estadísticas consolidadas de centrales, actualizadas solo al cambiar _centrales

  // ==============================
  // 4️⃣ Efectos reactivos
  // ==============================
  private initEffect = effect(() => {
    if (this._centrales().length === 0) {
      this.loadCentrales(); // Carga inicial de datos simulados o API
    }
  }, { allowSignalWrites: true });

  private logEffect = effect(() => {
    console.log('Centrales actualizadas:', this._centrales());
    console.log('Estadísticas actuales:', this.estadisticas());
  }); // Log automático al cambiar la lista de centrales

  // ==============================
  // 5️⃣ Helpers privados
  // ==============================
  private delay = (ms: number) => new Promise<void>(resolve => setTimeout(resolve, ms)); // Simula retardo de API

  private actualizarTimestamp() {
    this._ultimaActualizacion.set(new Date()); // Actualiza fecha de última modificación
  }

  // ==============================
  // 6️⃣ Métodos públicos / CRUD
  // ==============================
  /**
   * Reemplaza todas las centrales
   */
  setCentrales = (centrales: Central[]): void => {
    this._error.set(null);
    this._centrales.set([...centrales]);
    this.actualizarTimestamp();
  };

  /**
   * Agrega una nueva central (asíncrono)
   */
  addCentral = async (central: Omit<Central, 'central_id'>): Promise<void> => {
    this._loading.set(true);
    this._error.set(null);
    try {
      await this.delay(200); // Simulación API
      const newId = Math.max(...this._centrales().map(c => c.central_id), 0) + 1;
      this._centrales.set([...this._centrales(), { ...central, central_id: newId }]);
      this.actualizarTimestamp();
    } catch (err: any) {
      this._error.set(err.message ?? 'Error agregando central');
    } finally {
      this._loading.set(false);
    }
  };

  /**
   * Actualiza una central existente
   */
  updateCentral = async (centralId: number, updatedData: Partial<Central>): Promise<void> => {
    this._loading.set(true);
    this._error.set(null);
    try {
      await this.delay(200); // Simulación API
      const copia = [...this._centrales()];
      const index = copia.findIndex(c => c.central_id === centralId);
      if (index !== -1) {
        copia[index] = { ...copia[index], ...updatedData };
        this._centrales.set(copia);
        this.actualizarTimestamp();
      } else {
        this._error.set('Central no encontrada');
      }
    } catch (err: any) {
      this._error.set(err.message ?? 'Error actualizando central');
    } finally {
      this._loading.set(false);
    }
  };

  /**
   * Elimina una central por ID
   */
  deleteCentral = async (centralId: number): Promise<void> => {
    this._loading.set(true);
    this._error.set(null);
    try {
      await this.delay(200); // Simulación API
      const copia = this._centrales().filter(c => c.central_id !== centralId);
      this._centrales.set(copia);
      this.actualizarTimestamp();
    } catch (err: any) {
      this._error.set(err.message ?? 'Error eliminando central');
    } finally {
      this._loading.set(false);
    }
  };

  /**
   * Obtiene una central por ID
   */
  getCentralById = (id: number): Central | undefined =>
    this._centrales().find(c => c.central_id === id);

  /**
   * Crea un computed de centrales filtradas según criterios
   */
  createFilteredCentrales = (filtro: {
    estado_operacion?: string;
    tipo_central?: string;
    ubicacion_estado?: string;
    searchText?: string;
  }) =>
    computed(() =>
      this._centrales().filter(c => {
        const matchEstado = !filtro.estado_operacion || c.estado_operacion === filtro.estado_operacion;
        const matchTipo = !filtro.tipo_central || c.tipo_central === filtro.tipo_central;
        const matchUbicacion = !filtro.ubicacion_estado || c.ubicacion_estado === filtro.ubicacion_estado;
        const matchSearch =
          !filtro.searchText ||
          c.nombre.toLowerCase().includes(filtro.searchText.toLowerCase()) ||
          c.ubicacion_estado.toLowerCase().includes(filtro.searchText.toLowerCase());
        return matchEstado && matchTipo && matchUbicacion && matchSearch;
      })
    );

  /**
   * Refresca los datos (mock o API)
   */
  refresh = async (): Promise<void> => {
    this._loading.set(true);
    try {
      await this.loadCentrales();
    } finally {
      this._loading.set(false);
    }
  };

  /**
   * Limpia todas las señales
   */
  clearData = (): void => {
    this._centrales.set([]);
    this._error.set(null);
    this._loading.set(false);
    this._ultimaActualizacion.set(null);
  };

  // ==============================
  // 7️⃣ Carga de datos mock
  // ==============================
  loadCentrales = async (): Promise<void> => {
    try {
      await this.delay(500); // Simulación retardo API
      const mockCentral: Central = {
        central_id: 1,
        nombre: 'Central Simulada',
        ubicacion_estado: 'Estado Ejemplo',
        tipo_central: 'Híbrida',
        estado_operacion: 'Operativa',
      };
      this._centrales.set([mockCentral]);
      this.actualizarTimestamp();
      console.log('Registro simulado cargado:', mockCentral);
    } catch (err: any) {
      this._error.set(err.message ?? 'Error cargando centrales');
    }
  };
}
