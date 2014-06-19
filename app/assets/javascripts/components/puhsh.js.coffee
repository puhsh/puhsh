# Public: A top level class that oversees all components
class @Puhsh
  constructor: () ->
    @grid = new Grid
    @cover_images = new CoverImage
