var puhsh = angular.module('puhsh.filters', []);

puhsh.filter('price', ['$filter', function($filter) {
  return function(input) {
    input = parseFloat(input);
    if (input % 1 === 0) {
      input = input.toFixed(0);
    }
    return input;
  };
}]);
