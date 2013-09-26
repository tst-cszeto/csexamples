'use strict'

@getMqServiceProviderInstance = ->
  provider = new BaseMqServiceProvider()
  provider.$get = provider.getMqServiceInstance
  provider.$get.$inject = ['DEFAULT_MQ_WS_URL', 'DEFAULT_USER', 'WebSocketConnector']
  return provider

angular.module('TstCoreServices')
  .provider 'MqService', @getMqServiceProviderInstance
