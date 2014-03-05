var puhsh = angular.module('puhsh');

puhsh.controller('PostsController', function($scope) {
  $scope.name = 'Bryan Mikaelian';

  $scope.bodyClass = function() {
    return 'dark';
  }

});
