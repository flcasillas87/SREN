import { ChangeDetectionStrategy, Component } from '@angular/core';

@Component({
  selector: 'app-consumos-form',
  standalone: true,
  templateUrl: './consumos-form.component.html',
  styleUrls: ['./consumos-form.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ConsumosFormComponent {}
