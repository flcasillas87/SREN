import { NgOptimizedImage } from '@angular/common';
import { ChangeDetectionStrategy, Component, input, Signal } from '@angular/core';

@Component({
  selector: 'app-header-logo',
  standalone: true,
  imports: [NgOptimizedImage],
  templateUrl: './header-logo.component.html',
  styleUrls: ['./header-logo.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class HeaderLogoComponent {
  /** Input como Signal, readonly y público para ESLint */
  public readonly logoSrc: Signal<string> = input<string>('assets/logo.png');
}
