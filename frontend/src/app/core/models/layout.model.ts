import { Type } from '@angular/core';

// Interfaz para el contenido del footer
export type Link = {
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
};

// Interfaz para el contenido del footer
export type FooterContent = {
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
};

// Otras interfaces relacionadas con el layout pueden ser añadidas aquí
// Ejemplo:
export type HeaderContent = {
  title: string;
  logoUrl: string;
  navLinks: { title: string; url: string }[];
};

export type MenuItem = {
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
};
