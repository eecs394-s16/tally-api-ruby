module Sequel
  class Model

    # Model attributes
    def self.unique_fields  ; [] end
    def self.required_fields; [] end

    # Aliases
    alias_method :orig_validate, :validate

    def getField(field)
      fk = self.call("#{field}_fk")
      instance = Object.const_get(field.capitalize).first(:id => fk)
      raise HttpError.new(404), "#{field.capitalize} with id #{fk} not found" if instance.nil?
      return instance
    end

    def self.fromID(id)
      instance = self[id]
      raise HttpError.new(404), "Could not find #{self} with id #{id}" if instance.nil?
      return instance
    end

  end
end

# Custom models
require_relative 'Collection.rb'
require_relative 'Item.rb'

# Packages
require_relative 'login_package.rb'
