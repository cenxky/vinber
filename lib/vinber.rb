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
    definitions.each do |name, values|
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
end

# Extend/Include to Rails
ActiveRecord::Base.extend Vinber
ActiveRecord::Base.extend Vinber::Value
ActiveRecord::Base.send(:include, Vinber::Value)

ApplicationHelper.extend Vinber::Value
ApplicationHelper.send(:include, Vinber::Value)
ApplicationHelper.send(:include, Vinber::List)

ApplicationController.extend Vinber::Value
ApplicationController.send(:include, Vinber::Value)
