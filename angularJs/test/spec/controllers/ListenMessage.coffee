'use strict'

describe 'Controller: ListenMessageCtrl', () ->

  # load the controller's module
  beforeEach module 'CSExamplesApp'

  ListenMessageCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, MockMQService) ->
    scope = $rootScope.$new()
    ListenMessageCtrl = $controller 'ListenMessageCtrl', {
      $scope: scope,
      MqService: MockMQService
    }
    fakeViewId = 1337
    scope.init(fakeViewId)
    scope.channelName = 'fakeChannel'

  it 'should be initialized with a viewId and defaults', ->
    expect(scope.viewId).toBeDefined()
    expect(scope.listening).toBe false
    expect(scope.content).toBe ""

  it 'should be able to listen for new messages', ->
    scope.listenMessage()
    expect(scope.listening).toBe true
    expect(scope.content.length).toBeGreaterThan 0

  it 'should be able to stop listening for messages', ->
    scope.listenMessage()
    scope.stopListenMessage()
    expect(scope.listening).toBe false
    expect(scope.content).toBe ""
