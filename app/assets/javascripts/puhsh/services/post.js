var puhsh = angular.module('puhsh.services', ['ngResource']);

puhsh.factory('Post', ['$resource', function($resource) {
  return $resource('/v1/cities/:city_id/users/:user_id/posts/:id', {city_id: '@city_id', user_id: '@user_id', id: '@id'}) 
}]);
