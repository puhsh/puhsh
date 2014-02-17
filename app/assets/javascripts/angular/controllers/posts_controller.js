puhsh.controller('PostsController', function($scope, $http) {
  $http({method: 'GET', url: '/v1/posts'}).
    success(function(data, status, headers, config) {
      $scope.posts = data.items;
      $scope.image = _.first(_.first(data.items).post_images);
    });
});
