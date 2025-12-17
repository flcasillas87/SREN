import { Type } from '@angular/core';

// Interfaz para el contenido del footer
export interface Link {
  links: {
    id?: string | number;
    url?: string;
    label?: string;
    name?: string;
    href?: string;
    icon?: string;
    iconComponent?: Type<unknown>;
    title?: string;
    variant?: string;
    divider?: boolean;
  }[];
}
export interface FooterLink {
  title: string;
  url: string;
  icon?: string;
}
// Interfaz para el contenido del footer
export interface FooterContent {
  contactInfo: string;
  links: {
    id?: string | number;
    url?: string;
    label?: string;
    name?: string;
    href?: string;
    icon?: string;
    iconComponent?: Type<unknown>;
    title?: string;
    variant?: string;
    divider?: boolean;
  }[];
  copyright: string;
}

// Otras interfaces relacionadas con el layout pueden ser añadidas aquí
// Ejemplo:
export interface HeaderContent {
  title: string;
  logoUrl: string;
  navLinks: { title: string; url: string }[];
}

export interface MenuItem {
  id: string | number;
  url: string;
  label?: string;
  name: string;
  href: string;
  icon?: string;
  iconComponent?: Type<unknown>;
  title?: string;
  variant?: string;
  divider?: boolean;
}
