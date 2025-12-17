import { Injectable } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class TranslationService {
  // ==============================
  // 🔹 Constructor
  // ==============================
  public constructor() {
    // Inicialización si es necesaria
  }

  // ==============================
  // 🔹 Métodos públicos
  // ==============================
  public translate(key: string): string {
    // Aquí iría la lógica real de traducción
    return key;
  }
}
