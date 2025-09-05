import { computed, Injectable, Signal,signal } from '@angular/core';

import { FooterContent } from '../models/layout.model';

@Injectable({ providedIn: 'root' })
export class FooterContentService {
  // ✅ Señal privada con tipo explícito
  private readonly _footerContent = signal<FooterContent>({
    contactInfo: 'Dirección: 123 Calle Principal, Ciudad',
    links: [
      { title: 'Inicio', url: '/', icon: 'home' },
      { title: 'Acerca de nosotros', url: '/about', icon: 'info' },
      { title: 'Contacto', url: '/contact', icon: 'contact_mail' },
      { title: 'Dashboard', url: '/dashboard', icon: 'dashboard' },
    ],
    copyright: '© 2025 Todos los derechos reservados.',
  });

  // ✅ Señal pública readonly
  readonly footerContent: Signal<FooterContent> =
    this._footerContent.asReadonly();

  // ✅ Computeds
  readonly totalLinks: Signal<number> = computed(
    () => this._footerContent().links.length,
  );
  readonly linkTitles: Signal<string[]> = computed(
    () =>
      this._footerContent()
        .links.map((link) => link.title)
        .filter((title): title is string => !!title), // filtra undefined o null
  );

  // -------------------------
  // 🔹 Métodos de actualización con tipo explícito
  // -------------------------
  updateContactInfo(info: string): void {
    this._footerContent.update((current: FooterContent) => ({
      ...current,
      contactInfo: info,
    }));
  }

  updateLinks(links: FooterContent['links']): void {
    this._footerContent.update((current: FooterContent) => ({
      ...current,
      links,
    }));
  }

  updateCopyright(copyright: string): void {
    this._footerContent.update((current: FooterContent) => ({
      ...current,
      copyright,
    }));
  }

  // -------------------------
  // 🔹 Métodos para manipular links individualmente
  // -------------------------
  addLink(link: FooterContent['links'][0]): void {
    this._footerContent.update((current: FooterContent) => ({
      ...current,
      links: [...current.links, link],
    }));
  }

  removeLink(title: string): void {
    this._footerContent.update((current: FooterContent) => ({
      ...current,
      links: current.links.filter((link) => link.title !== title),
    }));
  }

  updateLink(
    oldTitle: string,
    updatedLink: Partial<FooterContent['links'][0]>,
  ): void {
    this._footerContent.update((current: FooterContent) => ({
      ...current,
      links: current.links.map((link) =>
        link.title === oldTitle ? { ...link, ...updatedLink } : link,
      ),
    }));
  }

  // -------------------------
  // 🔹 Métodos de utilidad
  // -------------------------
  getLinkByTitle(title: string): FooterContent['links'][0] | undefined {
    return this._footerContent().links.find((link) => link.title === title);
  }
}
