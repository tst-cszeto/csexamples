'use strict'

angular.module('CSExamplesApp')
  .controller 'MainCtrl', ($scope) ->
    $scope.modules = [
      {name: 'Message Queue Connector Library', route: 'mqexample/'}
      {name: 'Authentication', route: 'authexample/'}
    ]
