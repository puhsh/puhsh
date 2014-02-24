var puhsh = angular.module('puhsh');

puhsh.controller('PostsController', ['$scope', 'Post', function($scope, Post) {
  Post.query().$promise.then(function(data) {
    $scope.posts = data.items;
    $scope.image = _.first(_.first($scope.posts).post_images);
    $scope.$on('load', function() {
      alert('h');
    });
  });
}]);
