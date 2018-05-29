module Vinber
  module Klass

    def vinber_list(attribute, options = {}, &block)
      klass = self
      raise VinberUndefined, "Vinber was undefined in #{klass.name}" unless klass.vinber_defined?

      need_tanslate = options.fetch(:t){true}
      if klass.vinber_defined? attribute
        attribute_vinber = klass.defined_vinbers[attribute.to_s]
        return attribute_vinber unless attribute_vinber.is_a?(Hash)

        attribute_vinber.map do |key, value|
          key = Vinber::Translate.new(klass, attribute, key).to_s if need_tanslate
          block_given?? block.call(key, value) : [key, value]
        end
      end.to_a
    end

    def vinber_value(attribute, key_or_value)
      klass = self
      raise VinberUndefined, "Vinber was undefined in #{klass.name}" unless klass.vinber_defined?

      if key_or_value.is_a?(Symbol)
        key = key_or_value
      else
        attribute_vinber = vinbers.defined_vinbers || {}
        key = attribute_vinber.key key_or_value
      end

      Vinber::Translate.new(klass, attribute, key).to_s
    end

  end
end
