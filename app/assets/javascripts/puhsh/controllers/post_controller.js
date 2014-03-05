var puhsh = angular.module('puhsh');

puhsh.controller('PostController', ['$scope', '$routeParams', '$filter', 'Post', function($scope, $routeParams, $filter, Post) {
  var id = $routeParams.id;
  $scope.name = 'Bryan Mikaelian, VP of Develpment';
  $scope.post = Post.get({id: id});

  $scope.price = function(item) {
    if (item && item.price_cents > 0) {
      return $filter('price')(item.price_cents / 100);
    } else {
      return 'FREE';
    }
  }

  $scope.priceClass = function(item) {
    if (item && item.price_cents > 0.0) {
      return 'not-free';
    }
  }
}]);
