require_relative 'vinber/version'
require_relative 'vinber/translate'
require_relative 'vinber/vinber_list'
require_relative 'vinber/vinber_value'
require_relative 'vinber/current_vinbers'

module Vinber
  class VinberUndefined < StandardError; end

  def self.extended(base)
    base.class_attribute(:defined_vinbers, instance_writer: false)
    base.defined_vinbers = {}
  end

  def inherited(base)
    base.defined_vinbers = defined_vinbers.deep_dup
    super
  end

  def vinber(definitions)
    need_validates = definitions.delete(:validates)
    definitions.each do |name, values|
      detect_vinber_conflict! name
      validates_from_vinber name, values if need_validates
      defined_vinbers[name.to_s] = case
      when values.is_a?(Hash)
        values.with_indifferent_access
      when values.is_a?(Array)
        values
      else
        Array.wrap values.to_s
      end
    end
  end

  def vinbers
    Vinber::CurrentVinbers.new defined_vinbers
  end

  def vinber_defined?(attr_key = nil)
    attr_key ? defined_vinbers.has_key?(attr_key.to_s) : defined_vinbers.present?
  end

  private

  VINBER_CONFLICT_MESSAGE = \
    "You tried to define a vinber named %{name} in %{klass}, but it's already defined by %{source}."

  def detect_vinber_conflict!(name)
    if vinber_defined?(name)
      raise_vinber_conflict_error(name, 'Vinber')
    elsif defined_enums[name.to_s]
      raise_vinber_conflict_error(name, 'Enum')
    end
  end

  def validates_from_vinber(name, val)
    val = val.is_a?(Hash) ? val.values : Array.wrap(val).flatten
    class_eval { validates name.to_sym, inclusion: {in: val} }
  end

  def raise_vinber_conflict_error(name, source)
    raise ArgumentError, VINBER_CONFLICT_MESSAGE % {
      name: name,
      klass: self.name,
      source: source
    }
  end

end

# Extend/Include to ActiveRecord::Base
ActiveRecord::Base.class_eval do
  extend  Vinber
  extend  Vinber::List
  include Vinber::Value
end
