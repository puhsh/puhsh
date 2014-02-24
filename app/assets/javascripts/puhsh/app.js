var puhsh = angular.module('puhsh', ['ngRoute']);

puhsh.config(['$routeProvider', function($routeProvider) {
  $routeProvider.
    when('/', { 
      controller: 'PostsController',
      templateUrl: 'assets/posts.html',
      // resolve: {
      //   posts: function(Posts) {
      //     return Posts();
      //   }
      // }
    }).when('/posts', {
      controller: 'PostsController',
      templateUrl: 'assets/posts.html',
      resolve: {
        posts: function(Posts) {
          return Posts();
        }
      }
    }).otherwise({ redirectTo: '/' });
}]);

puhsh.config(['$locationProvider', function($locationProvider) {
  $locationProvider.html5Mode(false).hashPrefix('!');
}]);
