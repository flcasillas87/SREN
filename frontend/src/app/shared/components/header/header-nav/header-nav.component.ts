import { ChangeDetectionStrategy,Component } from '@angular/core';
import { RouterModule } from '@angular/router';

@Component({
  selector: 'app-header-nav',
  standalone: true,
  imports: [RouterModule],
  templateUrl: './header-nav.component.html',
  styleUrls: ['./header-nav.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class HeaderNavComponent {
  menuItems = [
    { label: 'Inicio', route: '/' },
    { label: 'Productos', route: '/productos' },
    { label: 'Contacto', route: '/contacto' }
  ];
}
