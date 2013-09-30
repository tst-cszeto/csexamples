'use strict'

angular.module('CSExamplesApp')
  .controller 'MonitorChannelCtrl', ($scope, MqService) ->
    $scope.init = (id)-> 
      $scope.viewId = id
      $scope.monitoring = false
      $scope.content = ""

    $scope.monitorChannel = ->
      $scope.monitoring = true
      statusCallback = (message) =>
        $scope.content= message.content
        $scope.$apply()
      $scope.callbackId = MqService.monitorChannelStatus($scope.channelName, statusCallback)

    $scope.stopMonitorChannel = ->
      $scope.monitoring = false
      $scope.content = ""
      MqService.stopMonitorChannelStatus($scope.channelName, $scope.callbackId)
