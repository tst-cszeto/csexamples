'use strict'

describe 'Controller: AuthexampleCtrl', () ->

  # load the controller's module
  beforeEach module 'CSExamplesApp'

  AuthexampleCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    AuthexampleCtrl = $controller 'AuthexampleCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
