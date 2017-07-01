module Vinber
  module List

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

  end
end
