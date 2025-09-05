import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component, effect, inject } from '@angular/core';

import {CentralesService } from '../services/centrales.service';

@Component({
  selector: 'app-centrales',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './centrales.component.html',
  styleUrls: ['./centrales.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class CentralesComponent {
  
    // 🔹 Effect de inicialización
  private readonly _initEffect = effect(() => {
    this._centralesService.loadCentrales();
  });

  // 🔹 Servicio inyectado
  private readonly _centralesService = inject(CentralesService);

  // 🔹 Señales públicas
  public readonly centrales = this._centralesService.centrales;
  public readonly loading = this._centralesService.loading;
  public readonly error = this._centralesService.error;


}

