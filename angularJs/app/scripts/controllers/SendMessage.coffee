'use strict'

angular.module('CSExamplesApp')
  .controller 'SendMessageCtrl', ($scope, MqService) ->
    $scope.init = (id)-> $scope.viewId = id
    $scope.sendMessage = ->
      MqService.sendMessages($scope.channelName, $scope.content)
