var puhsh = angular.module('puhsh');

puhsh.controller('PostsController', ['$scope', 'Post', function($scope, Post) {
  Post.get().$promise.then(function(results) {
    $scope.posts = results.items;
  });
}]);
