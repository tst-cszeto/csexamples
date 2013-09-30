'use strict'

angular.module('CSExamplesApp')
  .controller 'ListenMessageCtrl', ($scope, MqService) ->
    $scope.init = (id)-> 
      $scope.viewId = id
      $scope.listening = false
      $scope.content = ""

    $scope.listenMessage = ->
      $scope.listening = true
      msgCallback = (message) =>
        $scope.content+= "\n#{message.content}"
        $scope.$apply()
      $scope.callbackId = MqService.listenChannel($scope.channelName, null, 0, msgCallback)

    $scope.stopListenMessage = ->
      $scope.listening = false
      $scope.content = ""
      MqService.stopListenChannel($scope.channelName, $scope.callbackId)
