'use strict'

describe 'Controller: SendMessageCtrl', () ->

  # load the controller's module
  beforeEach module 'CSExamplesApp'

  SendMessageCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SendMessageCtrl = $controller 'SendMessageCtrl', {
      $scope: scope
    }
    fakeViewId = 1337
    scope.init(fakeViewId)

  it 'should be initialized with a viewId', () ->
    expect(scope.viewId).toBeDefined()

  it 'should be able to send a message to a channel', () ->
    scope.channelName = 'fakeChannel'
    scope.content = 'fakeContent'
    scope.sendMessage()
