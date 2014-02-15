var puhsh = angular.module('puhshApp', []);

puhsh.controller('PostsController', function($scope, $http) {
<<<<<<< HEAD
  $http.get('/v1/posts').success(function(data, status, headers, config) {
    $scope.items = data.items;
  });
=======
  $http({method: 'GET', url: '/v1/posts'}).
    success(function(data, status, headers, config) {
      $scope.posts = [data.items[0]];
    });
>>>>>>> Trying to get a post to render
});
