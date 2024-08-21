import { Component } from '@angular/core';
import { MatIcon } from '@angular/material/icon';
import { MatListModule } from '@angular/material/list';
import { MenuItem } from '../../../../core/models/navigation.model';

@Component({
  selector: 'app-sidebar-nav',
  standalone: true,
  imports: [MatListModule, MatIcon],
  templateUrl: './sidebar-nav.component.html',
  styleUrl: './sidebar-nav.component.css',
})
export class SidebarNavComponent {
  
    
}

