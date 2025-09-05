import { NgOptimizedImage } from '@angular/common';
import { ChangeDetectionStrategy, Component, input } from '@angular/core';

@Component({
  selector: 'app-header-logo',
  standalone: true,
  imports: [NgOptimizedImage],
  templateUrl: './header-logo.component.html',
  styleUrls: ['./header-logo.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class HeaderLogoComponent {
   // Input como signal, readonly para cumplir ESLint
  readonly logoSrc = input<string>('assets/logo.png');
}
