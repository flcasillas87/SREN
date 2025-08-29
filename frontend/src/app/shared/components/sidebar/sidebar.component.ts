import { ChangeDetectionStrategy, Component, signal } from '@angular/core';
import { SidebarHeaderComponent } from './sidebar-header/sidebar-header.component';
import { SidebarNavComponent } from './sidebar-nav/sidebar-nav.component';

export interface NavItem  {
  label: string;
  route: string;
};

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [SidebarHeaderComponent, SidebarNavComponent],
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class SidebarComponent {
  readonly navItems = signal<NavItem[]>([
    { label: 'Dashboard', route: '/' },
    { label: 'Usuarios', route: '/usuarios' },
    { label: 'Ajustes', route: '/ajustes' }
  ]);

  readonly title = signal('Menú');
}
