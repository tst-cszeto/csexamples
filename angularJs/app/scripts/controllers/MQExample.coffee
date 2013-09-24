'use strict'

angular.module('CSExamplesApp') 
  .controller 'MQExampleCtrl', ($scope, MqService) ->
    $scope.mqUrl = 'ws://localhost:8884/mq'
    $scope.mqViews = {}
    $scope.nextViewId = 0
    $scope.connected = MqService.isConnected()
    $scope.actions = [
      { text: 'Get channel status', url: '/views/channelstatus.html' }
      { text: 'Send messages', url: '/views/sendmessage.html' }
      { text: 'Listen for messages', url: '/views/listenmessage.html' }
      { text: 'Monitor channel status', url: '/views/monitorchannel.html'}
    ]

    $scope.addMQView = (action)=>
      $scope.mqViews[++$scope.nextViewId] = { url: action.url }

    $scope.closeMqView = (viewId) -> delete $scope.mqViews[viewId]

    $scope.onMQViewLoad = ()=> $scope.selectedAction = ''      

    $scope.connectToMQ = =>
      callback = =>
        $scope.connected = MqService.isConnected()
      MqService.connect($scope.mqUrl, callback)

    $scope.disconnectFromMQ = =>
      callback = =>
        $scope.connected = MqService.isConnected()
        $scope.mqViews = {}
        $scope.selectedAction = ''
        $scope.$apply()
      MqService.disconnect(callback)
