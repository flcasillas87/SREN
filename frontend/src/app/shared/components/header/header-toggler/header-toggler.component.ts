import { ChangeDetectionStrategy, Component, output } from '@angular/core';

@Component({
  selector: 'app-header-toggler', // ✅ coincide con archivo y uso
  standalone: true,
  templateUrl: './header-toggler.component.html',
  styleUrls: ['./header-toggler.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HeaderTogglerComponent {
  /** Evento público para notificar el toggle del sidebar */
  public readonly sidebarToggle = output<void>();

  /** Dispara el evento de toggle del sidebar */
  public onSidebarToggle(): void {
    this.sidebarToggle.emit();
  }
}
