import { TestBed } from '@angular/core/testing';

import { CentralContext } from './central-context';

describe('CentralContext', () => {
  let service: CentralContext;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(CentralContext);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
