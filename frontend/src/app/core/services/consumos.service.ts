import { HttpClient } from '@angular/common/http';
import { computed, inject, signal } from '@angular/core';
import { catchError, of, tap } from 'rxjs';

export interface Consumption {
  id: string;
  value: number;
  date: string;
}

export const consumptionService = (() => {
  const http = inject(HttpClient);

  // ⚡ Signal que almacena todos los consumos
  const consumptions = signal<Consumption[]>([]);

  // ⚡ Computed derivado: total de consumos
  const totalConsumption = computed(() => consumptions().reduce((acc, c) => acc + c.value, 0));

  // ⚡ Effect opcional: carga inicial de consumos desde backend
  const loadConsumptions = () => {
    http
      .get<Consumption[]>('/api/consumptions')
      .pipe(
        tap((data) => consumptions.set(data)),
        catchError((err) => {
          console.error('Error cargando consumos', err);
          return of([]);
        }),
      )
      .subscribe();
  };

  // ⚡ Llamada automática al inicializar singleton
  loadConsumptions();

  // ⚡ Método para agregar consumo
  const addConsumption = (consumption: Omit<Consumption, 'id'>) => {
    const newConsumption: Consumption = {
      ...consumption,
      id: crypto.randomUUID(),
    };

    return http.post<Consumption>('/api/consumptions', newConsumption).pipe(
      tap(() => {
        // Solo actualiza signal si la petición fue exitosa
        consumptions.update((current) => [...current, newConsumption]);
      }),
      catchError((err) => {
        console.error('Error agregando consumo', err);
        return of(null);
      }),
    );
  };

  return {
    consumptions,
    totalConsumption,
    addConsumption,
    loadConsumptions,
  };
})();
