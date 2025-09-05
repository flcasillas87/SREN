export interface Price {
  id: string;
  date: Date;
  value: number;
  currency: 'USD' | 'MXN';
  provider: string;
}

export interface PriceForm {
  date: string;
  value: string;
  currency: 'USD' | 'MXN';
  provider: string;
}
