var puhsh = angular.module('puhsh');

puhsh.controller('PostsController', ['$scope',
  function($scope, posts) {
    $scope.posts = posts.items;
    $scope.image = _.first(_.first(data.items).post_images);
}]);
