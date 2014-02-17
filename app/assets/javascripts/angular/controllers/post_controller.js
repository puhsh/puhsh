puhsh.controller('PostController', function($scope, $routeParams) {
  $scope.post = posts[$routeParams.id];
});
