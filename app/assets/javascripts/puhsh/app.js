var puhsh = angular.module('puhsh', 
     ['ngRoute']);

puhsh.config(['$routeProvider', function($routeProvider) {
  $routeProvider.
    when('/', { 
      controller: 'PostsController',
      templateUrl: 'assets/posts.html',
    }).when('/posts', {
      controller: 'PostsController',
      templateUrl: 'assets/posts.html',
    }).when('/posts/:id', {
      controller: 'PostController',
      templateUrl: 'assets/post.html',
    }).otherwise({ redirectTo: '/' });
}]);
