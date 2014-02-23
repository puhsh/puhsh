var puhsh = angular.module('puhshApp', ['ngRoute']);

function postsRouteConfig($routeProvider) {
  $routeProvider.
  when('/', { 
    controller: 'PostsController',
    templateUrl: 'assets/posts.html'
  }).
  when('/posts', { 
    controller: 'PostsController',
    templateUrl: 'assets/posts.html'
  }).
  when('/posts/:id', {
    controller: 'PostController',
    templateUrl: 'assets/posts.html'
  }).
  otherwise({
    redirectTo: '/'
  });
}

function locationProviderConfig($locationProvider) {
  $locationProvider
    .html5Mode(false)
    .hashPrefix('!');
};

puhsh.config(postsRouteConfig);
puhsh.config(locationProviderConfig);
