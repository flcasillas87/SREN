import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CentralHistoricoPage } from './central-historico.page';

describe('CentralHistoricoPage', () => {
  let component: CentralHistoricoPage;
  let fixture: ComponentFixture<CentralHistoricoPage>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CentralHistoricoPage]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CentralHistoricoPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
