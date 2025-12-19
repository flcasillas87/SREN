
import { ChangeDetectionStrategy, Component, effect, inject, signal } from '@angular/core';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { MatTableModule } from '@angular/material/table';

import { Central } from '../../core/models/central.model';
import { CentralesService } from '../../core/services/centrales.service';

@Component({
  selector: 'app-centrales-list',
  standalone: true,
  imports: [MatProgressSpinnerModule, MatTableModule],
  templateUrl: './centrales-list.component.html',
  styleUrls: ['./centrales-list.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class CentralesListComponent {
  // =========================
  // 1️⃣ Private fields
  // =========================
  private readonly _centralesService = inject(CentralesService);
  private readonly _initEffect = effect(
    () => {
      this.loading.set(true);
      const data = this._centralesService.centrales(); // accede a la señal del servicio
      this.centrales.set(data);
      this.loading.set(false);
    },
    { allowSignalWrites: true },
  );

  // =========================
  // 2️⃣ Public fields
  // =========================
  public readonly centrales = signal<Central[]>([]);
  public readonly loading = signal<boolean>(false);
  public readonly displayedColumns: string[] = [
    'central_id',
    'nombre',
    'estado_operacion',
    'tipo_central',
    'ubicacion_estado',
    'ubicacion_municipio',
    'capacidad_mw',
    'combustible_principal',
    'combustible_secundario',
  ];
}
