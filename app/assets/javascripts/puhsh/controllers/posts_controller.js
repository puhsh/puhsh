var puhsh = angular.module('puhsh');

puhsh.controller('PostsController', function($scope) {
  $scope.name = 'Bryan Mikaelian';
  $scope.id = 13;

  $scope.bodyClass = function() {
    return 'dark';
  }

});
