import { ChangeDetectionStrategy, Component, Input, signal } from '@angular/core';
import { SideNavItemComponent } from '../side-nav-item/side-nav-item.component';
import { NavItem } from '../sidebar.component';

@Component({
  selector: 'app-sidebar-nav',
  standalone: true,
  imports: [],
  templateUrl: './sidebar-nav.component.html',
  styleUrls: ['./sidebar-nav.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class SidebarNavComponent {
  
  // lista de items como signal readonly
  @Input() data!: NavItem;
fadeState: any;
}
