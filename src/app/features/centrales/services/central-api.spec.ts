import { TestBed } from '@angular/core/testing';

import { CentralApi } from './central-api';

describe('CentralApi', () => {
  let service: CentralApi;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(CentralApi);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
