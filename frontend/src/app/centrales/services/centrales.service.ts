import { computed, effect, Injectable, signal } from '@angular/core';

/** Modelo Central en camelCase */
export interface Central {
  centralId: number;
  nombre: string;
  ubicacionEstado: string;
  tipoCentral: string;
  estadoOperacion: string;
}

/**
 * Servicio centralizado para gestión de centrales eléctricas usando señales de Angular
 */
@Injectable({ providedIn: 'root' })
export class CentralesService {
  // ==============================
  // 1️⃣ Señales privadas
  // ==============================
  private readonly _centrales = signal<Central[]>([]);
  private readonly _loading = signal<boolean>(false);
  private readonly _error = signal<string | null>(null);
  private readonly _ultimaActualizacion = signal<Date | null>(null);

  // ==============================
  // 2️⃣ Efectos reactivos privados
  // ==============================
  private readonly _initEffect = effect(() => {
    if (this._centrales().length === 0) {
      this.loadCentrales();
    }
  }, { allowSignalWrites: true });

  private readonly _logEffect = effect(() => {
    console.log('Centrales actualizadas:', this._centrales());
    console.log('Estadísticas actuales:', this.estadisticas());
  });

  // ==============================
  // 3️⃣ Señales públicas (readonly)
  // ==============================
  public readonly centrales = this._centrales.asReadonly();
  public readonly loading = this._loading.asReadonly();
  public readonly error = this._error.asReadonly();
  public readonly ultimaActualizacion = this._ultimaActualizacion.asReadonly();

  // ==============================
  // 4️⃣ Computed / métricas derivadas
  // ==============================
  public readonly centralesOperativas = computed(() =>
    this.centrales().filter(c => c.estadoOperacion === 'Operativa')
  );

  public readonly centralesEnMantenimiento = computed(() =>
    this.centrales().filter(c => c.estadoOperacion === 'En mantenimiento')
  );

  public readonly totalCentrales = computed(() => this.centrales().length);

  public readonly centralesPorEstado = computed<Record<string, number>>(() =>
    this.centrales().reduce((acc, c) => {
      acc[c.ubicacionEstado] = (acc[c.ubicacionEstado] || 0) + 1;
      return acc;
    }, {} as Record<string, number>)
  );

  public readonly centralesPorTipo = computed<Record<string, number>>(() =>
    this.centrales().reduce((acc, c) => {
      acc[c.tipoCentral] = (acc[c.tipoCentral] || 0) + 1;
      return acc;
    }, {} as Record<string, number>)
  );

  public readonly estadisticas = computed(() => ({
    total: this.totalCentrales(),
    operativas: this.centralesOperativas().length,
    enMantenimiento: this.centralesEnMantenimiento().length,
    porcentajeOperativo:
      this.totalCentrales() > 0
        ? (this.centralesOperativas().length / this.totalCentrales()) * 100
        : 0,
    porEstado: this.centralesPorEstado(),
    porTipo: this.centralesPorTipo(),
    ultimaActualizacion: this._ultimaActualizacion() ? this._ultimaActualizacion()!.toISOString() : null,
  }));

  // ==============================
  // 5️⃣ Helpers privados
  // ==============================
  private readonly _delay = (ms: number) => new Promise<void>(resolve => setTimeout(resolve, ms));

  private _actualizarTimestamp(): void {
    this._ultimaActualizacion.set(new Date());
  }

  // ==============================
  // 6️⃣ CRUD públicos
  // ==============================
  public setCentrales = (centrales: Central[]): void => {
    this._error.set(null);
    this._centrales.set([...centrales]);
    this._actualizarTimestamp();
  };

  public addCentral = async (central: Omit<Central, 'centralId'>): Promise<void> => {
    this._loading.set(true);
    this._error.set(null);
    try {
      await this._delay(200);
      const newId = Math.max(...this._centrales().map(c => c.centralId), 0) + 1;
      this._centrales.set([...this._centrales(), { ...central, centralId: newId }]);
      this._actualizarTimestamp();
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Error agregando central';
      this._error.set(errorMessage);
    } finally {
      this._loading.set(false);
    }
  };

  public updateCentral = async (centralId: number, updatedData: Partial<Central>): Promise<void> => {
    this._loading.set(true);
    this._error.set(null);
    try {
      await this._delay(200);
      const copia = [...this._centrales()];
      const index = copia.findIndex(c => c.centralId === centralId);
      if (index !== -1) {
        copia[index] = { ...copia[index], ...updatedData };
        this._centrales.set(copia);
        this._actualizarTimestamp();
      } else {
        this._error.set('Central no encontrada');
      }
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Error actualizando central';
      this._error.set(errorMessage);
    } finally {
      this._loading.set(false);
    }
  };

  public deleteCentral = async (centralId: number): Promise<void> => {
    this._loading.set(true);
    this._error.set(null);
    try {
      await this._delay(200);
      this._centrales.set(this._centrales().filter(c => c.centralId !== centralId));
      this._actualizarTimestamp();
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Error eliminando central';
      this._error.set(errorMessage);
    } finally {
      this._loading.set(false);
    }
  };

  public getCentralById = (id: number): Central | undefined =>
    this._centrales().find(c => c.centralId === id);

  public createFilteredCentrales = (filtro: {
    estadoOperacion?: string;
    tipoCentral?: string;
    ubicacionEstado?: string;
    searchText?: string;
  }) =>
    computed(() =>
      this._centrales().filter(c => {
        const matchEstado = !filtro.estadoOperacion || c.estadoOperacion === filtro.estadoOperacion;
        const matchTipo = !filtro.tipoCentral || c.tipoCentral === filtro.tipoCentral;
        const matchUbicacion = !filtro.ubicacionEstado || c.ubicacionEstado === filtro.ubicacionEstado;
        const matchSearch =
          !filtro.searchText ||
          c.nombre.toLowerCase().includes(filtro.searchText.toLowerCase()) ||
          c.ubicacionEstado.toLowerCase().includes(filtro.searchText.toLowerCase());
        return matchEstado && matchTipo && matchUbicacion && matchSearch;
      })
    );

  public refresh = async (): Promise<void> => {
    this._loading.set(true);
    try {
      await this.loadCentrales();
    } finally {
      this._loading.set(false);
    }
  };

  public clearData = (): void => {
    this._centrales.set([]);
    this._error.set(null);
    this._loading.set(false);
    this._ultimaActualizacion.set(null);
  };

  // ==============================
  // 7️⃣ Carga de datos mock
  // ==============================
  public loadCentrales = async (): Promise<void> => {
    try {
      await this._delay(500);
      const mockCentral: Central = {
        centralId: 1,
        nombre: 'Central Simulada',
        ubicacionEstado: 'Estado Ejemplo',
        tipoCentral: 'Híbrida',
        estadoOperacion: 'Operativa',
      };
      this._centrales.set([mockCentral]);
      this._actualizarTimestamp();
      console.log('Registro simulado cargado:', mockCentral);
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Error cargando centrales';
      this._error.set(errorMessage);
    }
  };
}
