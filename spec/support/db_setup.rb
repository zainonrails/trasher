require 'active_record'

db_config = YAML.load_file(File.join('spec', 'config', 'database.yml'))
app_root = File.expand_path('../..', __FILE__)
db_dir = File.join(app_root, 'db')
ActiveRecord::Tasks::DatabaseTasks.database_configuration = db_config
ActiveRecord::Tasks::DatabaseTasks.db_dir = db_dir
ActiveRecord::Tasks::DatabaseTasks.root = app_root
ActiveRecord::Tasks::DatabaseTasks.env = 'test'

# create database specified in config/database.yml
ActiveRecord::Tasks::DatabaseTasks.create(db_config['test'])
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: db_config['test']['database']
)

# migrate database
ActiveRecord::Schema.verbose = true
ActiveRecord::Schema.define(version: 1) do
  create_table :users do |t|
    t.integer :name
    t.integer :email
    t.timestamp :deleted_at
    t.integer :deleted_by_id
  end

  create_table :posts do |t|
    t.integer :user_id
    t.string :content
  end
end