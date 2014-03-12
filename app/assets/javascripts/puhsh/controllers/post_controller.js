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

  $scope.imageBlockGridClass = function(post_images) {
    var numOfElements = _.size(post_images);
    if (numOfElements === 2) {
      return 'double small-block-grid-' + numOfElements;
    } else {
      return 'small-block-grid-' + numOfElements;
    }
  }

  $scope.pickUpName = function(pick_up_location) {
    switch(pick_up_location) {
      case 'porch':
        return 'Porch Pick Up';
        break;
      case 'public_location':
        return 'Public Location';
        break;
      case 'house':
        return 'In My House';
        break;
      default:
        return 'Other';
    }
  }

  $scope.categorySubcategoryName = function(category_name, subcategory_name) {
    return category_name + " : " + subcategory_name;
  }

  $scope.postedAt = function(created_at) {
    return moment(created_at).format('MMMM Do YYYY, h:mm A');
  }
}]);
