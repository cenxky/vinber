module Vinber
  class CurrentVinbers

    attr :vinbers

    def initialize(vinbers = {})
      @vinbers = vinbers.with_indifferent_access
    end

    def method_missing(name, *args)
      if vinbers.has_key? name
        vinbers[name]
      else
        super
      end
    end

  end
end
