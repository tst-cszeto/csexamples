'use strict'

angular.module('CSExamplesApp')
  .controller 'MonitorChannelCtrl', ($scope, MockMQService) ->
    $scope.init = (id)-> 
      $scope.viewId = id
      $scope.monitoring = false
      $scope.content = ""

    $scope.monitorChannel = ->
      $scope.monitoring = true
      callback = (message) => $scope.content= message
      MockMQService.monitorChannel($scope.channelName, callback)

    $scope.stopMonitorChannel = ->
      $scope.monitoring = false
      $scope.content = ""
      MockMQService.stopMonitorChannel($scope.channelName)
