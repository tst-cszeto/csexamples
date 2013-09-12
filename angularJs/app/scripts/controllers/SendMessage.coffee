'use strict'

angular.module('CSExamplesApp')
  .controller 'SendMessageCtrl', ($scope, MockMQService) ->
    $scope.init = (id)-> $scope.viewId = id
    $scope.sendMessage = ->
      MockMQService.sendMessage($scope.channelName, $scope.content)
