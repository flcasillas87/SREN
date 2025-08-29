export interface Central {
  central_id: number;
  nombre: string;
  ubicacion_estado: string;
  ubicacion_municipio?: string;
  tipo_central: string;
  estado_operacion: string;
  capacidad_mw?: number;
  combustible_principal?: string;
  combustible_secundario?: string;
}

