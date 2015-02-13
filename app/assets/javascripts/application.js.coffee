#= require jquery
#= require foundation
#= require peek.js
#= require peek/views/performance_bar

#
# Bower Components
#
#= require masonry/dist/masonry.pkgd.min
#= require jquery-waypoints/waypoints.min
#= require jquery-waypoints/shortcuts/infinite-scroll/waypoints-infinite.min
#= require underscore/underscore
#= require spin.js/spin.js
#= require spin.js/jquery.spin.js
#= require jquery-backstretch/jquery.backstretch.min.js
#= require backbone/backbone.js
#= require react/react.min.js

#= Bacbkone app
#= require_tree ./components
#= require app/app

$(() ->
  puhsh = new Puhsh()
  $(document).foundation()
)
