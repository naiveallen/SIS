require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'

# setup a db file named hw02.db
# DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/hw02.db")

configure :development, :test do
    DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/hw02.db")
end

configure :production do
    DataMapper.setup(:default, ENV['DATABASE_URL'])
end

# student model mapper
class Student
    include DataMapper::Resource
    property :id, Serial
    property :firstname, String
    property :lastname, String
    property :address, String
    property :email, String
    property :birthday, Date
    property :gender, Integer
end

# comment model mapper
class Comment
    include DataMapper::Resource
    property :id, Serial
    property :name, String
    property :content, Text
    property :created_at, DateTime
end


DataMapper.finalize

