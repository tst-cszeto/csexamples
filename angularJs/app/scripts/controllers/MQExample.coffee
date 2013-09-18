'use strict'

angular.module('CSExamplesApp') 
  .controller 'MQExampleCtrl', ($scope, MockMQService) ->
    $scope.mqUrl = 'ws://localhost:8884/mq'
    $scope.mqViews = {}
    $scope.nextViewId = 0
    $scope.connected = MockMQService.isConnected
    $scope.actions = [
      { text: 'Get channel status', url: '/views/channelstatus.html' }
      { text: 'Send messages', url: '/views/sendmessage.html' }
      { text: 'Listen for messages', url: '/views/listenmessage.html' }
      { text: 'Monitor channel status', url: '/views/monitorchannel.html'}
    ]

    $scope.addMQView = (action)=>
      $scope.mqViews[$scope.nextViewId] = { url: action.url }
      $scope.nextViewId++

    $scope.closeMqView = (viewId) -> delete $scope.mqViews[viewId]

    $scope.onMQViewLoad = ()=> $scope.selectedAction = ''      

    $scope.connectToMQ = =>
      callback = => $scope.connected = MockMQService.isConnected
      MockMQService.connect($scope.mqUrl, callback)

    $scope.disconnectFromMQ = =>
      callback = =>
        $scope.connected = MockMQService.isConnected
        $scope.mqViews = {}
        $scope.selectedAction = ''
      MockMQService.disconnect(callback)
