'use strict';

angular.module('TstCoreServices', [])

  #TODO find the right default server to point to
  .constant('DEFAULT_MQ_WS_URL', 'ws://localhost:8884/mq')
  .constant('DEFAULT_USER', 'unknown')
