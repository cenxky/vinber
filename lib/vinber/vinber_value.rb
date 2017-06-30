module Vinber
  module Value
    extend self

    def vinber_value(obj, attribute, options = {})
      klass = obj.class
      raise VinberUndefined, "vinber was undefined in #{obj.class.name}" unless klass.vinber_defined?

      val = obj.send(attribute.to_sym)
      if klass.vinber_defined?(attribute) &&
        (attribute_vinber = klass.defined_vinbers[attribute.to_s]).is_a?(Hash)

        attribute_vinber_key = attribute_vinber.invert[val]
        Vinber::Translate.new(klass, attribute, attribute_vinber_key)
      else
        val
      end
    end

  end
end

