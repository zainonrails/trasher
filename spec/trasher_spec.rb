require 'spec_helper'
require 'models/user'
require 'models/post'

RSpec.describe Trasher do
  it 'has a version number' do
    expect(Trasher::VERSION).not_to be nil
  end

  context 'when module is added to a model' do
    it 'refuses to be included in a non-AR' do
      expect do
        Class.new { include Trasher }
      end.to raise_error(RuntimeError, /only include this/)
    end

    it 'refuses to be added to a model without deleted_at' do
      expect do
        Post.include(Trasher)
        Post.lets_trash
      end.to raise_error(Trasher::MissingColumn, /deleted_at/)
    end

    it 'refuses to be added to a model without deleted_at' do
      expect do
        Post.include(Trasher)
        Post.lets_trash
      end.to raise_error(Trasher::MissingColumn, /deleted_at/)
    end
  end

  context 'when object is deleted' do
    it 'sets deleted_at attribute on user when deleted' do
      to_be_deleted = User.create(name: 'to_be_deleted', email: 'to_be_deleted@email.com')
      deleter = User.create(name: 'deleter', email: 'deleter@email.com')
      to_be_deleted.trash!(deleter)
      expect(to_be_deleted.deleted_at).not_to be_nil
    end

    it 'sets deleted_by_id attribute on user when deleted' do
      to_be_deleted = User.create(name: 'to_be_deleted', email: 'to_be_deleted@email.com')
      deleter = User.create(name: 'deleter', email: 'deleter@email.com')
      to_be_deleted.trash!(deleter)
      expect(to_be_deleted.deleted_by_id).not_to be_nil
    end

    it 'sets deleted_by_id of user that deletes it' do
      to_be_deleted = User.create(name: 'to_be_deleted', email: 'to_be_deleted@email.com')
      deleter = User.create(name: 'deleter', email: 'deleter@email.com')
      to_be_deleted.trash!(deleter)
      expect(to_be_deleted.deleted_by_id).to eq(deleter.id)
    end
  end

  context 'when object is recovered' do
    it 'updates deleted_at to nil' do
      to_be_deleted = User.create(name: 'to_be_deleted', email: 'to_be_deleted@email.com')
      deleter = User.create(name: 'deleter', email: 'deleter@email.com')
      to_be_deleted.trash!(deleter)
      to_be_deleted.recover!
      expect(to_be_deleted.deleted_at).to be_nil
    end

    it 'sets deleted_by_id to nil' do
      to_be_deleted = User.create(name: 'to_be_deleted', email: 'to_be_deleted@email.com')
      deleter = User.create(name: 'deleter', email: 'deleter@email.com')
      to_be_deleted.trash!(deleter)
      to_be_deleted.recover!
      expect(to_be_deleted.deleted_by_id).to be_nil
    end
  end
end
