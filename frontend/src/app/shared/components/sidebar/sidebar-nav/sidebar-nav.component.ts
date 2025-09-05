import { ChangeDetectionStrategy, Component, Input, signal } from '@angular/core';

@Component({
  selector: 'app-sidebar-nav',
  standalone: true,
  imports: [],
  templateUrl: './sidebar-nav.component.html',
  styleUrls: ['./sidebar-nav.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class SidebarNavComponent {
  // 🔹 Señal privada para los datos del item
  private readonly _data = signal<{
    id: number;
    name: string;
    link: string;
    icon?: string;
  } | null>(null);

  // 🔹 Señal pública solo lectura para el template
  public readonly data = this._data.asReadonly();

  /** Input para recibir datos del componente padre */
  @Input()
  public set item(value: { id: number; name: string; link: string; icon?: string }) {
    this._data.set(value);
  }
}
