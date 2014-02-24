var services = angular.module('puhsh.services', ['ngResource']);

services.factory('Post', ['$resource',
  function($resource) {
    return $resource('/v1/posts/:id', { id: '@id' });
  }
]);

services.factory('Posts', ['Post', '$q',
  function(Post, $q) {
    var delay = $q.defer();
    Post.query(function(posts) {
      delay.resolve(posts);
    }, function() {
      delay.reject('Unable to fetch posts');
    });

    return delay.promise;
  }
]);
