
import { ChangeDetectionStrategy, Component, effect, inject } from '@angular/core';
import { RouterModule,RouterOutlet } from '@angular/router';

import { CentralesService } from '../../../../core/services/centrales.service';

@Component({
  selector: 'app-centrales',
  standalone: true,
  imports: [RouterModule, RouterOutlet],
  templateUrl: './centrales.component.html',
  styleUrls: ['./centrales.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class CentralesComponent {

    // 🔹 Servicio inyectado
  private readonly _centralesService = inject(CentralesService);
  
  // 🔹 Effect de inicialización
  private readonly _initEffect = effect(() => {
    this._centralesService.loadCentrales();
  });



  // 🔹 Señales públicas
  public readonly centrales = this._centralesService.centrales;
  public readonly loading = this._centralesService.loading;
  public readonly error = this._centralesService.error;
}
