module Puhsh
  module Geolocation
    include Carmen

    def states
      @united_states.subregions.select { |x| x.type == 'state' }
    end

  end
end
