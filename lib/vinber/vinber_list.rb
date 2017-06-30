module Vinber
  module List
    extend self

    def vinber_list(klass, attribute, options = {})
      klass = Object.const_get(klass.to_s.camelize) if klass.is_a?(Symbol) || klass.is_a?(String)
      raise VinberUndefined, "Vinber was undefined in #{klass.name}" unless klass.vinber_defined?

      if klass.vinber_defined? attribute
        attribute_vinber = klass.defined_vinbers[attribute.to_s]
        return [] unless attribute_vinber.is_a?(Hash)

        attribute_vinber.map do |key, value|
          [Vinber::Translate.new(klass, attribute, key).to_s, value]
        end
      end.to_a
    end

  end
end
