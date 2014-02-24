var services = angular.module('puhsh.services', ['ngResource']);

services.factory('Post', ['$resource', function($resource) {
  return $resource('/v1/posts/:id.json', {id: '@id'});
}]);

services.factory('Posts', ['$resource', function($resource) {
  return $resource('/v1/posts.json');
}]);
