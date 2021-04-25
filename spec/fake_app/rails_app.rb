# frozen_string_literal: true

require 'active_record/railtie'

# configurations
class ArroefTestApp < Rails::Application
  config.eager_load = false
  config.root = __dir__
end
Rails.application.initialize!

# migrations
ActiveRecord::Tasks::DatabaseTasks.drop_current 'test'
ActiveRecord::Tasks::DatabaseTasks.create_current 'test'

class CreateTables < ActiveRecord::Migration[6.0]
  def self.up
    create_table(:users) { |t| t.string :name, null: false }
  end
end
CreateTables.up

# models
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: { writing: :primary, reading: :replica }
end

class User < ApplicationRecord
  validates :name, presence: true
end
