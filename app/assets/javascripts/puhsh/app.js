var puhsh = angular.module('puhsh', ['puhsh.services','ngRoute']);

puhsh.config(['$routeProvider', function($routeProvider) {
  $routeProvider.
    when('/', { 
      controller: 'PostsController',
      templateUrl: 'assets/posts.html',
    }).when('/posts', {
      controller: 'PostsController',
      templateUrl: 'assets/posts.html',
    }).otherwise({ redirectTo: '/' });
}]);
