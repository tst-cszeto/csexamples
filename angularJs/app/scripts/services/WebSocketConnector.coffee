'use strict'

@getBaseWebSocketConnectorInstance = ->
  return new BaseWebSocketConnector()

angular.module('TstCoreServices')
  .service 'WebSocketConnector', @getBaseWebSocketConnectorInstance
