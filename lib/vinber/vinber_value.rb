module Vinber
  module Value

    def vinber_value(attribute, options = {})
      obj   = self
      klass = obj.class
      val   = obj.send(attribute.to_sym)
      api   = options.fetch(:t) {false}

      if klass.vinber_defined?(attribute) &&
        (attribute_vinber = klass.defined_vinbers[attribute.to_s]).is_a?(Hash)

        attribute_vinber_key = attribute_vinber.key val
        api ? attribute_vinber_key.to_s : Vinber::Translate.new(klass, attribute, attribute_vinber_key).to_s
      else
        val
      end
    end

  end
end

