var puhsh = angular.module('puhsh');

puhsh.controller('PostsController', ['$scope', 'Posts', function($scope, Posts) {
  $scope.posts = Posts.get();
  $scope.posts.$promise.then(function(results) {
    $scope.posts = results.items;
  });
}]);
