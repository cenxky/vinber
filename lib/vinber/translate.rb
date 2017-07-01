module Vinber
  class Translate

    VALUE_LABLE = "vinber.%{klass}.%{attribute}_%{key}"

    def initialize(klass, attribute, attribute_vinber_key)
      @label = {
        :klass     => (klass.is_a?(Class) ? klass.name : klass),
        :attribute => attribute,
        :key       => attribute_vinber_key
      }
    end

    def label
      @label ||= %()
    end

    def text
      @text ||= I18n.t (VALUE_LABLE % label), default: label[:key].to_s.humanize
    end

    alias_method :to_s, :text

  end
end
