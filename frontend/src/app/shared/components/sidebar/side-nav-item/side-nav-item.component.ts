import { ChangeDetectionStrategy, Component, Input, signal } from '@angular/core';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-side-nav-item',
  standalone: true,
  imports: [RouterModule],
  templateUrl: './side-nav-item.component.html',
  styleUrls: ['./side-nav-item.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class SideNavItemComponent {
  // 🔹 Señales privadas
  private readonly _label = signal('');
  private readonly _route = signal('');

  // 🔹 Señales públicas solo lectura para el template
  public readonly label = this._label.asReadonly();
  public readonly route = this._route.asReadonly();

  /** Input para recibir datos del componente padre */
  @Input()
  public set data(item: { label: string; route: string }) {
    this._label.set(item.label);
    this._route.set(item.route);
  }
}
