import { ChangeDetectionStrategy, Component } from '@angular/core';

@Component({
  selector: 'app-header-divider',
  standalone: true,
  templateUrl: './header-divider.component.html',
  styleUrls: ['./header-divider.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HeaderDividerComponent {}
