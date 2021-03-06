'use strict'

describe 'Controller: MainCtrl', () ->

  # load the controller's module
  beforeEach module 'CSExamplesApp'

  MainCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller 'MainCtrl', {
      $scope: scope
    }

  it 'should attach two modules to the scope', () ->
    expect(scope.modules.length).toBe 2
