import { ChangeDetectionStrategy, Component } from '@angular/core';
import { RouterModule } from '@angular/router';

interface MenuItem {
  label: string;
  route: string;
}

@Component({
  selector: 'app-header-nav', // ✅ coincide con el archivo y uso
  standalone: true,
  imports: [RouterModule],
  templateUrl: './header-nav.component.html',
  styleUrls: ['./header-nav.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HeaderNavComponent {
  /** Ítems de navegación para el header */
  public readonly menuItems: MenuItem[] = [
    { label: 'Inicio', route: '/' },
    { label: 'Productos', route: '/productos' },
    { label: 'Contacto', route: '/contacto' },
  ];
}
