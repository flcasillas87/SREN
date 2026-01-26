import { computed, effect, Injectable, Signal, signal } from '@angular/core';
import { Central } from '@models/central.model';

import { EstadoOperacion, TipoCentral } from '../enums';

@Injectable({ providedIn: 'root' })
export class CentralesService {
  // =========================
  // 1️⃣ State (signals primero)
  // =========================
  private readonly _centrales = signal<Central[]>([]);
  private readonly _loading = signal(false);
  private readonly _error = signal<string | null>(null);

  // =========================
  // 2️⃣ Effects (después del state)
  // =========================
  private readonly _logEffect = effect(() => {
    console.log('Centrales actualizadas:', this._centrales());
  });

  // =========================
  // 3️⃣ Public readonly signals
  // =========================
  public readonly centrales: Signal<Central[]> = this._centrales.asReadonly();
  public readonly loading: Signal<boolean> = this._loading.asReadonly();
  public readonly error: Signal<string | null> = this._error.asReadonly();

  // =========================
  // 4️⃣ Computed
  // =========================
  public readonly totalCentrales = computed(() => this._centrales().length);

  // =========================
  // 5️⃣ Public API
  // =========================
  public loadCentrales(): void {
    this._loading.set(true);

    setTimeout(() => {
      try {
        const mock: Central[] = [
          {
            centralId: 1,
            nombre: 'Central Simulada',
            ubicacionEstado: 'Estado Ejemplo',
            tipoCentral: TipoCentral.TERMICA,
            estadoOperacion: EstadoOperacion.OPERATIVA,
          },
          {
            centralId: 2,
            nombre: 'Central Secundaria',
            ubicacionEstado: 'Estado Ejemplo',
            tipoCentral: TipoCentral.TERMICA,
            estadoOperacion: EstadoOperacion.OPERATIVA
          },
        ];

        this._centrales.set(mock);
        this._error.set(null);
      } catch (err) {
        this._error.set(
          err instanceof Error ? err.message : 'Error cargando centrales',
        );
      } finally {
        this._loading.set(false);
      }
    }, 500);
  }
}
