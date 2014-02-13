var puhsh = angular.module('puhshApp', []);

puhsh.controller('PostsController', function($scope, $http) {
  $http.get('/v1/posts').success(function(data, status, headers, config) {
    $scope.items = data.items;
  });
});
