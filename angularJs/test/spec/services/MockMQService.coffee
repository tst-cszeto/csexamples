'use strict'

describe 'Service: MockMQService', () ->

  # load the service's module
  beforeEach module 'CSExamplesApp'

  # instantiate service
  MockMQService = {}
  beforeEach inject (_MockMQService_) ->
    MockMQService = _MockMQService_

  it 'should do something', () ->
    expect(!!MockMQService).toBe true
