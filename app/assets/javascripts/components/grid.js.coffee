# Public: A class responsible for configuring masonry.js and infinite scroll
class @Grid
  constructor: () ->
    @masonryColumnWidth = 220
    @masonryItemSelector = '.item'
    @masonryGutterSize = 20
    @masonryTransitionDuration = '0.2s'

    @_setupMasonry()
    @_setupInfiniteScroll()

  # Private: Configures elements with class .js-grid-list to follow a Masonry.js style layout
  #
  # Returns nothing.
  _setupMasonry: () ->
    $('.js-grid-list').masonry(columnWidth: @masonryColumnWidth, itemSelector: @masonryItemSelector, gutter: @masonryGutterSize, transitionDuration: @masonryTransitionDuration)

  # Private: Configures elements with class .js-infinite to use an infinite scrolling technique with jquery.waypointsn
  #
  # Returns nothing.
  _setupInfiniteScroll: () ->
    $('.js-infinite').waypoint('infinite',
                               items: @masonryItemSelector,
                               onBeforePageLoad: @_infiniteBeforePageLoad,
                               onAfterPageLoad: @_infiniteAfterPageLoad)

  # Private: A function that is called before infinite scrolling occurs
  #
  # Returns a function.
  _infiniteBeforePageLoad: () ->
    $('.item').addClass('loaded')

  # Private: A function that is called after infinite scrolling occurs
  #
  # Returns a function.
  _infiniteAfterPageLoad: () ->
    $('.js-grid-list').masonry('appended', $('.item').not('.loaded'))

