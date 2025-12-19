export interface Central {
  centralId: number;
  nombre: string;
  ubicacionEstado: string;
  ubicacionMunicipio?: string;
  tipoCentral: string;
  estadoOperacion: string;
  capacidadMw?: number;
  combustiblePrincipal?: string;
  combustibleSecundario?: string;
}
