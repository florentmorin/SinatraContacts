#!/usr/bin/env ruby
#encoding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra-env'
require 'sinatra/contrib'
require 'haml'
require 'dm-core'
require 'dm-migrations'
require 'dm-serializer'

if Sinatra.env.development?
  require 'dm-sqlite-adapter'
end

if Sinatra.env.production?
  require 'dm-postgres-adapter'
end
require 'json'

## Initial setup ##

configure do
  set :show_exceptions, false
end

if Sinatra.env.development?
  DataMapper.setup( :default, "sqlite3://#{Dir.pwd}/database.db" )
end

if Sinatra.env.production?
  DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
end

# Contact model
class Contact
  include DataMapper::Resource
 
  property :id, Serial
  property :firstname, String
  property :lastname, String
  property :email, String
end
 
DataMapper.auto_upgrade!

## Web interface ##

# Home page 
get '/' do
  redirect '/contacts/'
end
 
# Show list of contacts
get '/contacts/', '/contacts' do
  haml :list, :locals => { :cs => Contact.all }
end
 
# Show form to create new contact
get '/contacts/new' do
  haml :form, :locals => {
    :c => Contact.new,
    :action => '/contacts/create'
  }
end
 
# Create new contact
post '/contacts/create' do
  c = Contact.new
  c.attributes = params
  c.save
 
  redirect("/contacts/#{c.id}")
end
 
# Show form to edit contact
get '/contacts/:id/edit' do|id|
  c = Contact.get(id)
  haml :form, :locals => {
    :c => c,
    :action => "/contacts/#{c.id}/update"
  }
end
 
# Edit a contact
post '/contacts/:id/update' do |id|
  c = Contact.get(id)
  c.update params
 
  redirect "/contacts/#{id}"
end
 
# Delete a contact
post '/contacts/:id/destroy' do |id|
  c = Contact.get(id)
  c.destroy
 
  redirect "/contacts/"
end
 
# View a contact
get '/contacts/:id' do |id|
  c = Contact.get(id)
  haml :show, :locals => { :c => c }
end


## REST API ##

# Read all
get '/api/contacts/', '/api/contacts' do
  content_type 'application/json'
  Contact.all.to_a.to_json
end

# Read a contact
get '/api/contacts/:id' do |id|
  c = Contact.get(id)
  
  if c.nil?
    status 404
    return
  end
  
  content_type 'application/json'
  c.to_json
end

# Create a contact
post '/api/contacts/', '/api/contacts' do
  payload = params
    
  if payload.empty?
    raw = request.env["rack.input"].read
    payload = JSON.parse raw
  end
  
  c = Contact.new
  c.attributes = payload
  c.save
  
  status 201
  content_type 'application/json'
  c.to_json
end

# Update a contact
put '/api/contacts/:id' do |id|
  raw = request.env["rack.input"].read
  payload = JSON.parse raw
  
  c = Contact.get(id)
  
  if c.nil?
    status 404
    return
  end
  
  c.update payload
  c.save
  
  status 200
  content_type 'application/json'
  c.to_json
end

# Delete a contact
delete '/api/contacts/:id' do |id|
  c = Contact.get(id)
  
  if c.nil?
    status 404
    return
  end
  
  c.destroy
  
  content_type 'application/json'
  status 204
end
