import { Injectable, inject } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';

@Injectable({ providedIn: 'root' })
export class ToastService {
  private snackBar = inject(MatSnackBar);

  success(message: string) {
    this.snackBar.open(message, 'Cerrar', {
      duration: 3000,
      panelClass: ['toast-success']
    });
  }

  error(message: string) {
    this.snackBar.open(message, 'Cerrar', {
      duration: 4000,
      panelClass: ['toast-error']
    });
  }
}