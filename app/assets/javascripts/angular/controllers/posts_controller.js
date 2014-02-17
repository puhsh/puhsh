puhsh.controller('PostsController', function($scope, $http) {
  $http({method: 'GET', url: '/v1/posts'}).
    success(function(data, status, headers, config) {
      $scope.posts = data.items;
      $scope.image = data.items[0].post_images[0];
    });
});
