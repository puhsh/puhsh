var puhsh = angular.module('puhshApp', []);

puhsh.controller('PostsController', function($scope) {
  $scope.items = [
    { title: 'Hello' }
  ];
});
