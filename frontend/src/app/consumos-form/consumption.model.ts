export interface Consumption {
  id: string;
  date: Date;
  central: string; // ID de la central generadora
  volume: number; // m³
  unit: 'BTU' | 'MWh';
}
