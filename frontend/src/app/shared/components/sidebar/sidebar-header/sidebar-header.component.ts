import { Component, ChangeDetectionStrategy, signal } from '@angular/core';

@Component({
  selector: 'app-sidebar-header',
  standalone: true,
  templateUrl: './sidebar-header.component.html',
  styleUrls: ['./sidebar-header.component.css'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class SidebarHeaderComponent {
  readonly title = signal('');
  set headerTitle(value: string) {
    this.title.set(value);
  }
}
