'use strict'

angular.module('CSExamplesApp')
  .controller 'ChannelStatusCtrl', ($scope, MqService) ->
    $scope.init = (id)-> $scope.viewId = id
    $scope.getChannelStatus = ->
      callback = (message) =>
        $scope.status = angular.toJson(message, true)
        $scope.$apply()
      MqService.getChannelStatus($scope.channelName, callback)
