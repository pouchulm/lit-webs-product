require 'bundler/setup'
Bundler.require

if development?
    ActiveRecord::Base.establish_connection("sqlite3:db/development.db")
end

class User < ActiveRecord::Base
    has_secure_password
    validates :name,
        presence: true
    validates :password,
        length: {in: 5..10},
        format: { with: /\A\w+\z/ }
    has_many :posts
end

class Post < ActiveRecord::Base

    belongs_to :user
end