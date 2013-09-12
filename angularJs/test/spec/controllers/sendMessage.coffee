'use strict'

describe 'Controller: SendmessageCtrl', () ->

  # load the controller's module
  beforeEach module 'CSExamplesApp'

  SendmessageCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SendmessageCtrl = $controller 'SendmessageCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', () ->
    expect(scope.awesomeThings.length).toBe 3
