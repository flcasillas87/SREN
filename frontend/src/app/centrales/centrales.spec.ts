import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Centrales } from './centrales.component';

describe('Centrales', () => {
  let component: Centrales;
  let fixture: ComponentFixture<Centrales>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [Centrales]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Centrales);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
