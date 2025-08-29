import { ChangeDetectionStrategy, Component,Input } from '@angular/core';

@Component({
  selector: 'app-sidebar-nav',
  standalone: true,
  imports: [],
  templateUrl: './sidebar-nav.component.html',
  styleUrls: ['./sidebar-nav.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class SidebarNavComponent {
    @Input() data!: { 
    id: number; 
    name: string; 
    link: string; 
    icon?: string 
  };

}
