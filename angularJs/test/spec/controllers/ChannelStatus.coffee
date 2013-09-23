'use strict'

describe 'Controller: ChannelStatusCtrl', () ->

  # load the controller's module
  beforeEach module 'CSExamplesApp'

  ChannelStatusCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, MockMQService) ->
    scope = $rootScope.$new()
    ChannelStatusCtrl = $controller 'ChannelStatusCtrl', {
      $scope: scope,
      MqService: MockMQService
    }
    fakeViewId = 1337
    scope.init(fakeViewId)
    scope.channelName = 'fakeChannel'

  it 'should be initialized with a viewId', () ->
    expect(scope.viewId).toBeDefined()

  it 'should be able to get channel status', () ->
    expect(scope.status).toBeUndefined()
    scope.channelName = 'fakeChannel'
    scope.getChannelStatus()
    expect(scope.status).toBeDefined()
