import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CentralDetallePage } from './central-detalle.page';

describe('CentralDetallePage', () => {
  let component: CentralDetallePage;
  let fixture: ComponentFixture<CentralDetallePage>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CentralDetallePage]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CentralDetallePage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
