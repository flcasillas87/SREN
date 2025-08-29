import {ChangeDetectionStrategy, Component,  input } from '@angular/core';

@Component({
  selector: 'app-header-text',
  standalone: true,
  templateUrl: './header-text.component.html',
  styleUrls: ['./header-text.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class HeaderTextComponent {
  // Input como signal
  readonly text = input<string>('');}
