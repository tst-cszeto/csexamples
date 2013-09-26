'use strict'

class @CallbackContainer
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
