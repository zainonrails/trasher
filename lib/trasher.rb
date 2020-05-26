require 'trasher/version'
require 'trasher/trashable'

module Trasher
  class Error < StandardError; end

  class TrashedWithoutTrashedBy < Error
    def message
      'Cannot trash record without deleted by.'
    end
  end

  class MissingColumn < Error
    def message
      'Missing deleted_at or deleted_by_id column(s)'
    end
  end


  def self.included(base)
    unless base.ancestors.include?(ActiveRecord::Base)
      raise "You can only include this if #{base} extends ActiveRecord::Base"
    end
    base.extend(ClassMethods)
  end

  def self.deleted_at_column?(klass)
    klass.columns.map(&:name).include?('deleted_at')
  end

  def self.deleted_by_column?(klass)
    klass.columns.map(&:name).include?('deleted_by_id')
  end

  module ClassMethods
    def lets_trash(options = {})
      unless Trasher.deleted_at_column?(self) && Trasher.deleted_by_column?(self)
        raise MissingColumn
      end
      include Trasher::Trashable

      return unless options[:default_scope]

      default_scope do
        where(deleted_at: nil, deleted_by: nil)
      end
    end
  end
end
