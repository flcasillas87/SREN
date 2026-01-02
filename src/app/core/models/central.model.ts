import { EstadoOperacion, TipoCentral } from '@enums';

export interface Central {
  centralId: number;
  nombre: string;
  ubicacionEstado?: string;
  ubicacionMunicipio?: string;

  tipoCentral: TipoCentral;
  estadoOperacion: EstadoOperacion;

  capacidadMw?: number;
  combustiblePrincipal?: string;
  combustibleSecundario?: string;
}
