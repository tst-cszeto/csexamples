tstCoreServices = angular.module('TstCoreServices', [])

#TODO find the right default server to point to
tstCoreServices.constant('DEFAULT_MQ_WS_URL', 'ws://localhost:8884/mq')
tstCoreServices.constant('DEFAULT_USER', 'unknown')

tstCoreServices.service('WebSocketConnector', ($q, $rootScope) ->
    @ws = null;
    @deferred = $q.defer()
    @messageCallbacks = {}
    @statusCallbacks = {}
    @oneTimeCallbacks = {}

    #convenience object to manipulate callback lists
    class CallbackContainer
        constructor: () ->
            @_callbacks = {}
            @_nextId = 0
        addCallback: (callback) ->
            @_callbacks[@_nextId] = callback
            @_nextId++
        removeCallback: (callbackToRemove) ->
            for own key, callback of @_callbacks
                if callback is callbackToRemove
                    delete @_callbacks[key]
        runCallbacks: (params, runOnceOnly) ->
            for own key, callback of @_callbacks
                callback(params)
                if runOnceOnly then delete @_callbacks[key]

    @init = (mqUrl) ->
        @ws = new WebSocket(mqUrl)

        @ws.onopen = angular.bind(@, @onOpenHandler)

        @ws.onmessage = angular.bind(@, (event) ->
            message = angular.fromJson(event.data)
            messageInfo = @getMessageInfo(message)
            messageType = messageInfo.type
            channel = messageInfo.channel
            channelCallbacks = @messageCallbacks
            runOnceOnly = false

            if messageType is 'status'
                channelCallbacks = @statusCallbacks
            else if messageType is 'oneTime'
                channelCallbacks = @oneTimeCallbacks
                runOnceOnly = true

            callbacks = channelCallbacks[channel]
            if not callbacks then return
            callbacks.runCallbacks(message, runOnceOnly)
        )

        @ws.onclose = (event) ->
            console.log('on close', event)

        @ws.onerror = (event) ->
            console.log('on error', event)

    @getMessageInfo = (message) ->
        messageInfo = {
            type: 'message',
            channel: message.channel
        }

        #check and see if it's a status message based message contents
        if message.consumerNames
            messageInfo.type = 'oneTime'
        content = message.content
        try
            content = angular.fromJson(message.content)
            if content.consumerNames
                messageInfo.type = 'status'
                messageInfo.channel = content.channel
        catch e
            return messageInfo
        return messageInfo

    @onOpenHandler = (event) ->
        console.log('fly like a g6')
        #this is pure magic...
        $rootScope.$apply(angular.bind(@, () ->
            @deferred.resolve())
        )

    @sendMessage = (payload) ->
        if @ws.readyState is WebSocket.OPEN
            @ws.send(payload)
        else
            promise = @deferred.promise
            promise.then( angular.bind(@, () ->
                @ws.send(payload)
            ))

    @addCallback = (channel, callback, type) ->
        channelCallbacks = @messageCallbacks
        if type is 'status' then channelCallbacks = @statusCallbacks
        else if type is 'oneTime' then channelCallbacks = @oneTimeCallbacks
        if not channelCallbacks[channel]
            channelCallbacks[channel] = new CallbackContainer()
        channelCallbacks[channel].addCallback(callback)

    @removeCallback = (channel, callbackToRemove, type) ->
        channelCallbacks = @messageCallbacks
        if type is 'status' then channelCallbacks = @statusCallbacks
        callbacks = channelCallbacks[channel]
        if not callbacks then return
        callbacks.removeCallback(callbackToRemove)
)

tstCoreServices.provider('MqService', () ->

    #This can be atmosphere, socketIO, or by default a simple websocket wrapper
    @mqConnector = null

    @mqUrl = null
    @userName = null

    #Configurable properties of the service provider
    @setMqConnector = (mqConnector) -> @mqConnector = mqConnector
    @setMqUrl = (mqUrl) -> @mqUrl = mqUrl
    @setUserName = (userName) -> @userName = userName

    @$get = (DEFAULT_MQ_WS_URL, DEFAULT_USER, WebSocketConnector) ->
        connector = @mqConnector || WebSocketConnector
        mqUrl = @mqUrl || DEFAULT_MQ_WS_URL
        userName = @userName || DEFAULT_USER
        connector.init(mqUrl)

        return {
            listenChannel: (channel, consumerName=userName, isB64=0, callback) ->
                if not channel then return
                payload = {
                    consumerName: consumerName,
                    action: 'listen',
                    isB64: isB64,
                    channel: channel
                }
                connector.sendMessage(angular.toJson(payload))
                connector.addCallback(channel, callback, 'message')

            stopListenChannel: (channel, callback) ->
                payload = {
                    action: 'stop_listen',
                    channel: channel
                }
                connector.sendMessage(angular.toJson(payload))
                connector.removeCallback(channel, callback, 'message')

            getChannelStatus: (channel, callback) ->
                payload = {
                    action: 'channel_status',
                    channel: channel
                }
                connector.sendMessage(angular.toJson(payload))
                connector.addCallback(channel, callback, 'oneTime')

            monitorChannelStatus: (channel, callback) ->
                payload = {
                    action: 'monitor_channel_status',
                    channel: channel
                }
                connector.sendMessage(angular.toJson(payload))
                connector.addCallback(channel, callback, 'status')

            stopMonitorChannelStatus: (channel, callback) ->
                payload = {
                    action: 'stop_monitor_channel_status',
                    channel: channel
                }
                connector.sendMessage(angular.toJson(payload))
                connector.removeCallback(channel, callback, 'status')

            sendMessages: (channel, messages, sourceName=userName, isB64=0) ->
                if not (channel and messages) then return
                if not angular.isArray(messages) then messages = [messages]
                payload = {
                    action: 'send',
                    isB64: isB64,
                    messages: @buildPayloadMessages(channel, messages, sourceName)
                }
                connector.sendMessage(angular.toJson(payload))

            sendMessagesToChannels: (channelMessages, sourceName=userName, isB64=0) ->
                if not channelMessages then return
                payloadMessages = []
                for channel in channelMessages
                    messages = channelMessages[channel]
                    payloadMessages.concat(@buildPayloadMessages(channel, messages, sourceName))

                payload = {
                    action: 'send',
                    isB64: isB64,
                    messages: payloadMessages
                }
                connector.sendMessages(angular.toJson(payload))

            buildPayloadMessages: (channel, messages, sourceName) ->
                payloadMessages = []
                for message in messages
                    payloadMessages.push({
                        channel: channel,
                        source: sourceName,
                        content: message
                    })
                return payloadMessages
        }
)
