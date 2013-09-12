'use strict'

describe 'Controller: ChannelStatusCtrl', () ->

  # load the controller's module
  beforeEach module 'CSExamplesApp'

  ChannelstatusCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    ChannelstatusCtrl = $controller 'ChannelstatusCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
