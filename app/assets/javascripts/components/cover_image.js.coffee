class @CoverImage
  constructor: () ->
    @coverImageSelector = ".js-cover-image"
    @defaultCoverImageBackground = "black"

    @bindCoverImages()


  # Public: Binds all UI elements with the class .js-cover-image to set a cover image to the url specified
  # in data-cover-image-url. If no url exists, the background is set to black
  #
  # Returns nothing
  bindCoverImages: () ->
    image_url = $(".js-cover-image").data("cover-image-url")
    if image_url
      $(@coverImageSelector).backstretch(image_url, {centeredY: false, fade: 500:})
    else
      $(".js-cover-image").css({background: @defaultCoverImageBackground})
