import { ChangeDetectionStrategy, Component } from '@angular/core';

@Component({
  selector: 'app-centrales-detail',
  imports: [],
  templateUrl: './centrales-detail.html',
  styleUrls: ['./centrales-detail.css'], // CORREGIDO
  changeDetection: ChangeDetectionStrategy.OnPush, // Mejor rendimiento
})
export class CentralesDetailComponent {
  // TODO: revisar DestroyRef + effect en servicio singleton
}
