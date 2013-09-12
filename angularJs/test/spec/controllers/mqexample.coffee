'use strict'

describe 'Controller: MQExampleCtrl', () ->

  # load the controller's module
  beforeEach module 'CSExamplesApp'

  MqexampleCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MqexampleCtrl = $controller 'MqexampleCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
