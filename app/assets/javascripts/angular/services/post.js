var services = angular.module('puhsh.services', ['ngResource']);


services.factory('Posts', ['$resource',
  function($resource) {
    return $resource('/v1/posts')
  }
]);


services.factory('Post', ['$resource',
  function($resource) {
    return $resource('/v1/posts/:id', { id: '@id' });
  }
]);
