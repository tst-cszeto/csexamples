'use strict'

describe 'Controller: MQExampleCtrl', () ->

  # load the controller's module
  beforeEach module 'CSExamplesApp'

  MQExampleCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope, MockMQService) ->
    scope = $rootScope.$new()
    MQExampleCtrl = $controller 'MQExampleCtrl', {
      $scope: scope,
      MqService: MockMQService
    }

  it 'should initialize the scope with various defaults', ->
    expect(scope.mqUrl).toBeDefined()
    expect(scope.mqViews).toEqual {}
    expect(scope.connected).toBe false
    expect(scope.actions.length).toBe 4

  it 'should be able to add a new mqView', ->
    viewId = scope.nextViewId + 1
    fakeAction = scope.actions[0]
    scope.addMQView(fakeAction)

    expect(scope.mqViews[viewId]).toBeDefined()
    expect(scope.nextViewId).toBe 1

  it 'should be able to close/remove a mqView', ->
    for fakeAction in scope.actions
       scope.addMQView(fakeAction)

    randomViewId = 2
    expect(scope.mqViews[randomViewId]).toBeDefined()
    scope.closeMqView(randomViewId)
    expect(scope.mqViews[randomViewId]).toBeUndefined()

  it 'should be able to connect to mq', ->
    scope.connectToMQ(scope.mqUrl)
    expect(scope.connected).toBe true

  it 'should be able to disconnect from mq', ->
    scope.connectToMQ(scope.mqUrl)
    scope.disconnectFromMQ()
    expect(scope.mqViews).toEqual {}
    expect(scope.selectedAction).toEqual ''
    expect(scope.connected).toBe false
