import { ChangeDetectionStrategy, Component } from '@angular/core';

@Component({
  selector: 'app-header-brand',
  standalone: true,
  templateUrl: './header-brand.component.html',
  styleUrls: ['./header-brand.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HeaderBrandComponent {}
