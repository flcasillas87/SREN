import { ChangeDetectionStrategy, Component, effect, inject, } from '@angular/core';

import { CentralesService } from '../services/centrales.service';
@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  standalone: true,
  selector: 'app-centrales',
  templateUrl: 'centrales.html',
  styleUrls: ['centrales.css'],
  imports: [],
})
export class CentralesComponent {
  private readonly centralesService = inject(CentralesService);
  readonly centrales = this.centralesService.centrales;

  // Efecto que carga las centrales al inicializar
  readonly init = effect(() => {
    // Ejecuta solo una vez porque no hay señales dentro
    this.centralesService.loadCentrales();
  });
}
