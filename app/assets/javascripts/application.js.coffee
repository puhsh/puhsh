#= require jquery
#= require foundation
#= require peek.js
#= require peek/views/performance_bar
#= require_tree ./components


#
# Bower Components
#
#= require masonry/dist/masonry.pkgd.min
#= require jquery-waypoints/waypoints.min
#= require jquery-waypoints/shortcuts/infinite-scroll/waypoints-infinite.min
#= require underscore/underscore
#= require spin.js/spin.js
#= require spin.js/jquery.spin.js

$(document).foundation()

$(() -> 
  puhsh = new Puhsh
  puhsh.initialize()
)
