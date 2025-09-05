import { computed, effect, Injectable, Signal,signal } from '@angular/core';

export interface Central {
  centralId: number;
  nombre: string;
  ubicacionEstado: string;
  tipoCentral: string;
  estadoOperacion: string;
}

@Injectable({ providedIn: 'root' })
export class CentralesService {
  // 🔹 Señal privada con las centrales
  private readonly _centrales = signal<Central[]>([]);
  private readonly _loading = signal(false);
  private readonly _error = signal<string | null>(null);

    // 🔹 Effect de logging
  private readonly _logEffect = effect(() => {
    console.log('Centrales actualizadas:', this._centrales());
  });

  // 🔹 Señales públicas readonly
  public readonly centrales: Signal<Central[]> = this._centrales.asReadonly();
  public readonly loading: Signal<boolean> = this._loading.asReadonly();
  public readonly error: Signal<string | null> = this._error.asReadonly();

  // 🔹 Computed: totales
  public readonly totalCentrales = computed(() => this._centrales().length);



  // =====================
  // Métodos públicos
  // =====================

  public loadCentrales(): void {
    this._loading.set(true);
    setTimeout(() => {
      try {
        const mock: Central[] = [
          {
            centralId: 1,
            nombre: 'Central Simulada',
            ubicacionEstado: 'Estado Ejemplo',
            tipoCentral: 'Híbrida',
            estadoOperacion: 'Operativa',
          },
          {
            centralId: 2,
            nombre: 'Central Secundaria',
            ubicacionEstado: 'Estado Ejemplo',
            tipoCentral: 'Térmica',
            estadoOperacion: 'En mantenimiento',
          },
        ];
        this._centrales.set(mock);
        this._error.set(null);
      } catch (err) {
        this._error.set(err instanceof Error ? err.message : 'Error cargando centrales');
      } finally {
        this._loading.set(false);
      }
    }, 500);
  }
}
