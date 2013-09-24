'use strict';

angular.module('CSExamplesApp')
  .service 'MockMQService', ->
    @userName = 'MockMQUser'
    @connected = false
    @isConnected = -> @connected
    @connect = (url, callback) ->
      @url = url
      console.log("MockMQ=> connecting to: #{ url }")
      @connected = true
      callback()

    @disconnect = (callback) ->
      console.log("MockMQ=> disconnecting from: #{ @url }")
      @connected = false
      callback()

    @getChannelStatus = (channelName, callback) ->
      console.log("MockMQ=> querying MQ for status on channel: #{ channelName }")
      fakeMsg = {
        consumerNames: ["fakeConsumer"]
        consumerCount: 1
        observerCount: 0
        channel: channelName,
        observerNames: []
      }
      callback(angular.toJson(fakeMsg, true))

    @sendMessages = (channelName, messages, sourceName=@userName, isB64=0) ->
      console.log("MockMQ=>sending msg: #{ messages } to MQ on channel: #{ channelName }")

    @listenChannel = (channelName, consumerName=@userName, isB64=0, callback) ->
      console.log("MockMQ=> listening for msgs on: #{ channelName }")
      fakeMsg = {
        content: "this a test message"
        time: 1375382297091
        source: "some_source_name"
        ttl: 719
        channel: channelName
        contentIsBinary: false
      }
      callback(fakeMsg)

    @stopListenChannel = (channelName, callback) ->
      console.log("MockMQ=> stop listening for msgs on: #{ channelName }")

    @monitorChannelStatus = (channelName, callback) ->
      console.log("MockMQ=> monitoring status on: #{ channelName }")
      fakeMsg = {
        content: "{\n \"consumerNames\": [\"test_page3\"],\n \"consumerCount\": 1,\n \"observerCount\": 0,\n \"channel\": \"some_channel_name\",\n \"observerNames\": []\n}",
        time: 1375387242433
        source: "__SYSTEM"
        ttl: 300
        channel: " #{ channelName } observer"
        contentIsBinary: false
      }
      callback(fakeMsg)

    @stopMonitorChannelStatus = (channelName) ->
      console.log("MockMQ=> stop monitoring status on: #{ channelName }")
