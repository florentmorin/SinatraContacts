# A simple Sinatra demo application

## Installation

1. Install Ruby 1.9+ ([RVM is highly recommended](https://rvm.io))
2. Install **bundler** gem
3. Run **bundle install** in source directory
4. Run server with **ruby server.rb**

## Deploy to heroku

1. Create account on [heroku](http://heroku.com)
2. Install [heroku client](https://toolbelt.herokuapp.com)
3. Create heroku app: **heroku create**
4. Install postgresql addon: **heroku addons:add heroku-postgresql:dev**
5. Get database URL: **heroku config | grep HEROKU_POSTGRESQL**
6. Establish primary db: **heroku pg:promote \_HEROKU\_POSTGRESQL\_<em>COLOR</em>\_URL\_**
7. Deploy: **git push heroku master**

## Usage

### Web application

Simply open application URL and enjoy.

### RESTful web service

Access API via **/api/** prefix.

<table border="1" cellspacing="0" cellpadding="4" style="border:0.5px solid
black;">
	<tr>
		<th>Action</th>
		<th>HTTP Request</th>
		<th>HTTP Body</th>
	<tr>
		<td>Get all contacts</td>
		<td>GET /api/contacts</td>
		<td>n/a</td>
	</tr>
	<tr>
		<td>Get contact identified by <em>id</em></td>
		<td>GET /api/contacts/<em>id</em></td>
		<td>n/a</td>
	</tr>
	<tr>
		<td>Create a contact</td>
		<td>POST /api/contacts</td>
		<td>JSON object or object properties as HTTP keys and values</td>
	</tr>
	<tr>
		<td>Update contact identified by <em>id</em></td>
		<td>PUT /api/contacts/<em>id</em></td>
		<td>JSON object or object properties as HTTP keys and values</td>
	</tr>
	<tr>
		<td>Delete contact identified by <em>id</em></td>
		<td>DELETE /api/contacts/<em>id</em></td>
		<td>n/a</td>
	</tr>
</table>