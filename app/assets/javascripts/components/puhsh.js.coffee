# Public: A top level class that oversees all components
class @Puhsh
  # Public: Initializes all components and assigns them to variables within this class
  #
  # Returns nothing
  initializeComponents: () ->
    @grid = new Grid
