'use strict'

angular.module('CSExamplesApp')
  .controller 'ListenMessageCtrl', ($scope, MockMQService) ->
    $scope.init = (id)-> 
      $scope.viewId = id
      $scope.listening = false
      $scope.content = ""

    $scope.listenMessage = ->
      $scope.listening = true
      callback = (message) => $scope.content+= "\n#{message}"
      MockMQService.listenChannel($scope.channelName, callback)

    $scope.stopListenMessage = ->
      $scope.listening = false
      $scope.content = ""
      MockMQService.stopListenChannel($scope.channelName)

