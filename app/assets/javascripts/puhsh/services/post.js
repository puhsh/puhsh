var puhsh = angular.module('puhsh.services', ['ngResource']);

puhsh.factory('Post', ['$resource', function($resource) {
  return $resource('/v1/posts/:id', {id: '@id'});
}]);
