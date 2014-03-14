var puhsh = angular.module('puhsh', 
     ['ngRoute',
      'puhsh.services',
      'puhsh.filters']);

puhsh.config(['$routeProvider', function($routeProvider) {
  $routeProvider.
    when('/', { 
      controller: 'PostsController',
      templateUrl: 'assets/posts.html',
    }).when('/posts', {
      controller: 'PostsController',
      templateUrl: 'assets/posts.html',
    }).when('/:city_id/:user_id/:id/', {
      controller: 'PostController',
      templateUrl: 'assets/post.html'
    }).otherwise({ redirectTo: '/' });
}]);
