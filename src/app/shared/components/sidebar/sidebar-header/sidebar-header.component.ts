import { ChangeDetectionStrategy, Component, signal } from '@angular/core';

@Component({
  selector: 'app-sidebar-header',
  standalone: true,
  templateUrl: './sidebar-header.component.html',
  styleUrls: ['./sidebar-header.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class SidebarHeaderComponent {
  // Signal privada
  private readonly _title = signal('');

  // Signal pública solo lectura para el template
  public readonly title = this._title.asReadonly();

  /** Método público para actualizar el título */
  public setTitle(value: string): void {
    this._title.set(value);
  }
}
