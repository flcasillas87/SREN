import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component, inject } from '@angular/core';
import { CentralesService } from '@services/centrales.service';

@Component({
  selector: 'app-central-list-page',
  imports: [CommonModule],
  templateUrl: './CentralListPage.html',
  styleUrls: ['./CentralListPage.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class CentralListPage {
  // =========================
  // 1️⃣ Inject services
  // =========================
  private readonly _centralesService = inject(CentralesService);

  // =========================
  // 2️⃣ State (consumed from service)
  // =========================
  public readonly centrales = this._centralesService.centrales;
  public readonly loading = this._centralesService.loading;
  public readonly total = this._centralesService.totalCentrales;

  // =========================
  // 3️⃣ UI config
  // =========================
  public readonly displayedColumns: readonly string[] = [
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

  // =========================
  // 4️⃣ Public actions
  // =========================
  public reload(): void {
    this._centralesService.loadCentrales();
  }
}
