import { ChangeDetectionStrategy, Component, input } from '@angular/core';

@Component({
  selector: 'app-header-text', // ✅ coincide con el archivo y uso
  standalone: true,
  templateUrl: './header-text.component.html',
  styleUrls: ['./header-text.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HeaderTextComponent {
  /** Texto recibido como input (signal) */
  public readonly text = input<string>('');
}
