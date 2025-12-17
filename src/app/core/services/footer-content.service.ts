import { computed, effect, Injectable, Signal, signal } from '@angular/core';

import { FooterContent, FooterLink } from '../models/layout.model';

@Injectable({ providedIn: 'root' })
export class FooterContentService {
  // ==============================
  // 1️⃣ Señales privadas
  // ==============================
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

  // ==============================
  // 2️⃣ Effects privados (opcional)
  // ==============================
  private readonly _saveEffect = effect(() => {
    localStorage.setItem('footerContent', JSON.stringify(this._footerContent()));
  });

  // ==============================
  // 3️⃣ Señales públicas readonly
  // ==============================
  public readonly footerContent: Signal<FooterContent> = this._footerContent.asReadonly();

  public readonly totalLinks: Signal<number> = computed(() => this._footerContent().links.length);

  public readonly linkTitles: Signal<string[]> = computed(() =>
    this._footerContent()
      .links.map((link) => link.title)
      .filter((title): title is string => !!title),
  );

  // ==============================
  // 4️⃣ Métodos de actualización
  // ==============================
  public updateContactInfo(info: string): void {
    this._footerContent.update((current) => ({
      ...current,
      contactInfo: info,
    }));
  }

  public updateLinks(links: FooterLink[]): void {
    this._footerContent.update((current) => ({ ...current, links }));
  }

  public updateCopyright(copyright: string): void {
    this._footerContent.update((current) => ({ ...current, copyright }));
  }

  // ==============================
  // 5️⃣ Manipulación individual de links
  // ==============================
  public addLink(link: FooterLink): void {
    this._footerContent.update((current) => ({
      ...current,
      links: [...current.links, link],
    }));
  }

  public removeLink(title: string): void {
    this._footerContent.update((current) => ({
      ...current,
      links: current.links.filter((link) => link.title !== title),
    }));
  }

  public updateLink(oldTitle: string, updatedLink: Partial<FooterLink>): void {
    this._footerContent.update((current) => ({
      ...current,
      links: current.links.map((link) => (link.title === oldTitle ? { ...link, ...updatedLink } : link)),
    }));
  }

  // ==============================
  // 6️⃣ Métodos de utilidad
  // ==============================
  public getLinkByTitle(title: string): FooterLink | undefined {
    const found = this._footerContent().links.find(
      (link): link is FooterLink => typeof link.title === 'string' && link.title === title,
    );
    return found;
  }
}
