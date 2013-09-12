'use strict'

angular.module('CSExamplesApp')
  .controller 'ChannelStatusCtrl', ($scope, MockMQService) ->
    $scope.init = (id)-> $scope.viewId = id
    $scope.getChannelStatus = ->
      callback = (message) => $scope.status = message
      MockMQService.getChannelStatus($scope.channelName, callback)
