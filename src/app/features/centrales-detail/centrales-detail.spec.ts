import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CentralesDetail } from './centrales-detail';

describe('CentralesDetail', () => {
  let component: CentralesDetail;
  let fixture: ComponentFixture<CentralesDetail>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CentralesDetail],
    }).compileComponents();

    fixture = TestBed.createComponent(CentralesDetail);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
