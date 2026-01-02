import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CentralOperacionPage } from './central-operacion.page';

describe('CentralOperacionPage', () => {
  let component: CentralOperacionPage;
  let fixture: ComponentFixture<CentralOperacionPage>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CentralOperacionPage],
    }).compileComponents();

    fixture = TestBed.createComponent(CentralOperacionPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
