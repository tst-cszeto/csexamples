'use strict'

class @BaseMqServiceProvider
  constructor: ()->
    #This can be atmosphere, socketIO, or by default a simple websocket wrapper
    mqConnector: null

    mqUrl: null
    userName: null

  #Configurable properties of the service provider
  setMqConnector: (mqConnector) -> @mqConnector = mqConnector
  setMqUrl: (mqUrl) -> @mqUrl = mqUrl
  setUserName: (userName) -> @userName = userName

  getMqServiceInstance: (url, user, connectorService)->
    return new BaseMqService(url, user, connectorService)
