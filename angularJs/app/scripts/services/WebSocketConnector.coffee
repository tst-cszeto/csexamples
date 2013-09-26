'use strict'

@getBaseWebSocketConnectorInstance = (renamed$q, renamed$rootScope) ->
  return new BaseWebSocketConnector(renamed$q, renamed$rootScope)

@getBaseWebSocketConnectorInstance.$inject = ['$q', '$rootScope']

angular.module('TstCoreServices')
  .service 'WebSocketConnector', @getBaseWebSocketConnectorInstance
