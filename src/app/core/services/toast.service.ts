import { inject, Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';

@Injectable({ providedIn: 'root' })
export class ToastService {
  // 🔹 Inyección privada de MatSnackBar
  private readonly _snackBar = inject(MatSnackBar);

  // 🔹 Duración de notificaciones en ms
  private readonly _successDurationMs = 3000;
  private readonly _errorDurationMs = 4000;

  /** Muestra un mensaje de éxito */
  public success(message: string): void {
    this._snackBar.open(message, 'Cerrar', {
      duration: this._successDurationMs,
      panelClass: ['toast-success'],
    });
  }

  /** Muestra un mensaje de error */
  public error(message: string): void {
    this._snackBar.open(message, 'Cerrar', {
      duration: this._errorDurationMs,
      panelClass: ['toast-error'],
    });
  }
}
