'use strict'

angular.module('CSExamplesApp', [])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/mqexample',
        templateUrl: 'views/mqexample.html',
        controller: 'MQExampleCtrl'
      .when '/authexample',
        templateUrl: 'views/authexample.html',
        controller: 'AuthExampleCtrl'
      .otherwise
        redirectTo: '/'
