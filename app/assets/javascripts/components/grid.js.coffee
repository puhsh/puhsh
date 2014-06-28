# Public: A class responsible for configuring masonry.js and infinite scroll
class @Grid
  constructor: () ->
    @masonryColumnWidth = 220
    @masonryItemSelector = '.item'
    @masonryStampItemSelector = '.item-sticky'
    @masonryGutterSize = 20
    @masonryTransitionDuration = '0.2s'

    @bindGridElements()

  # Public: Binds all elements with the class js-grid-list to Masonry grid
  bindGridElements: () ->
    # Initialize Masonry.js
    $('.js-grid-list').masonry()

    # Setup all the components for a .js-grid-list
    @_stampElements()
    @_setupMasonry()
    @_setupInfiniteScroll()


  # Private: Configures elements with class .js-grid-list to follow a Masonry.js style layout
  #
  # Returns nothing.
  _setupMasonry: () ->
    $('.js-grid-list').masonry(columnWidth: @masonryColumnWidth, itemSelector: @masonryItemSelector, gutter: @masonryGutterSize, transitionDuration: @masonryTransitionDuration, isFitWidth: true)


  # Private: Cofigures any elements with the class ".item-sticky" to be stamped in the masonry grid
  # 
  # Returns nothing.
  _stampElements: () ->
    $('.js-grid-list').masonry('stamp', @masonryStampItemSelector)

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

