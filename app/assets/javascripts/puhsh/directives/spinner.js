var directives = angular.module('puhsh.directives.spinner', []);

directives.directive('spinner', ['$timeout', function($timeout) {
  return {
    link: function(scope, element, attrs) {
      var opts = {
        lines: 13,
        length: 20,
        width: 10,
        radius: 30,
        corners: 1,
        rotate: 0,
        direction: 1,
        color: '#fff',
        speed: 1,
        trail: 60,
        shadow: true,
        hwaccel: false,
        className: 'spinner',
        zIndex: 2e9,
        top: 'auto',
        left: 'auto'
      };
      
      var spinner = new Spinner(opts).spin();
      element.append(spinner.el);
    }

  }
}]);
