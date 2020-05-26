module Trasher
  module Trashable
    def self.included(base)
      base.belongs_to :deleted_by,
                      class_name: 'User',
                      foreign_key: :deleted_by_id,
                      optional: true

      base.extend(ClassMethods)
    end

    module ClassMethods
      def with_deleted
        scope = all
        scope.where_clause.send(:predicates).delete(with_deleted_scope_sql)
        scope
      end

      def with_deleted_scope_sql
        all.table[:deleted_at].eq(nil).to_sql
      end
    end
  end

  def trashed?
    deleted_at.present?
  end

  def trash!(trashed_by, trashed_at = nil)
    raise TrashedWithoutTrashedBy unless trashed_by.present?

    trashed_at ||= DateTime.now
    _trash(trashed_at, trashed_by.try(:id))
  end

  def recover!
    _trash(nil, nil)
  end

  private

  def _trash(deleted_at, deleted_by_id)
    update_columns(deleted_at: deleted_at, deleted_by_id: deleted_by_id)
  end
end