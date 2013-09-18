'use strict'

describe 'Controller: MonitorChannelCtrl', () ->

  # load the controller's module
  beforeEach module 'CSExamplesApp'

  MonitorChannelCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MonitorChannelCtrl = $controller 'MonitorChannelCtrl', {
      $scope: scope
    }
    fakeViewId = 1337
    scope.init(fakeViewId)
    scope.channelName = 'fakeChannel'

  it 'should be initialized with a viewId and defaults', ->
    expect(scope.viewId).toBeDefined()
    expect(scope.monitoring).toBe false
    expect(scope.content).toBe ""

  it 'should be able to listen for new messages', ->
    scope.monitorChannel()
    expect(scope.monitoring).toBe true
    expect(scope.content.length).toBeGreaterThan 0

  it 'should be able to stop listening for messages', ->
    scope.monitorChannel()
    scope.stopMonitorChannel()
    expect(scope.monitoring).toBe false
    expect(scope.content).toBe ""
