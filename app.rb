require 'sinatra'
require 'sinatra/reloader' if development?
require './model'
require 'date'


configure do
    set :bind, '0.0.0.0'
    set :environment, :development
    set :show_exceptions, false
    enable :sessions
    set :username, "admin"
    set :password, "123456"
end


get '/' do 
    @title = 'Home'
    @isLogin = session[:isLogin]
    erb :home
end

get '/about' do 
    @title = 'About'
    @isLogin = session[:isLogin]
    erb :about
end

get '/contact' do 
    @title = 'Contact'
    @isLogin = session[:isLogin]
    erb :contact
end


# get all students
get '/students' do 
    @isLogin = session[:isLogin]
    @title = 'Students'
    @students = Student.all
    erb :students
end


# if user is not login, send the login view to the browser.
get '/students/new' do 
    halt redirect to('/login') unless session[:isLogin]
    @isLogin = session[:isLogin]
    @title = 'New student'
    erb :new_student
end


# if the student with specific id is not found, then send a 404 page. 
get '/students/:id' do 
    @isLogin = session[:isLogin]
    @student = Student.get(params[:id])
    if @student
        @title = @student.firstname + " " + @student.lastname
        erb :show_student
    else  
        erb :notfound
    end
end


# if user is not login, send the login view to the browser.
post '/students/new' do
    halt redirect to('/login') unless session[:isLogin]
    student = Student.new
    student.firstname = params[:firstname]
    student.lastname = params[:lastname]
    student.email = params[:email]
    student.address = params[:address]
    student.birthday = Date.parse(params[:birthday]) 
    student.gender = params[:gender]
    student.save()
    redirect to('/students')
end


# if user is not login, send the login view to the browser.
# if the student with specific id is not found, then send a 404 page. 
get '/students/:id/edit' do
    halt redirect to('/login') unless session[:isLogin]
    @isLogin = session[:isLogin]
    @title = 'Edit Student'
    @student = Student.get(params[:id])
    if @student
        erb :edit_student
    else
        erb :notfound
    end
end


# update a student profile. if user is not login, send the login view to the browser.
put '/students/:id' do 
    halt redirect to('/login') unless session[:isLogin]
    student = Student.get(params[:id])
    student.update(firstname: params[:firstname], lastname: params[:lastname],
                    email: params[:email], address: params[:address], 
                    birthday: Date.parse(params[:birthday]), gender: params[:gender]) if student
    redirect ("/students/#{params[:id]}")
end


# delete the student with specific id
delete '/students/:id' do
    halt redirect to('/login') unless session[:isLogin]
    student = Student.get(params[:id])
    student.destroy if student
    redirect to('/students')
end


# get all comments
get '/comments' do 
    @isLogin = session[:isLogin]
    @title = 'Comments'
    @comments = Comment.all
    erb :comments
end


get '/comments/new' do
    @isLogin = session[:isLogin]
    @title = 'New comment'
    erb :new_comment
end


post '/comments/new' do
    comment = Comment.new
    comment.name = params[:name]
    comment.content = params[:content]
    comment.save()
    redirect to('/comments')
end


# if the comment with specific id is not found, then send a 404 page. 
get '/comments/:id' do
    @isLogin = session[:isLogin]
    @comment = Comment.get(params[:id])
    @title = @comment.name
    if @comment
        erb :show_comment
    else
        erb :notfound
    end
end


# delete the comment with specific id
delete '/comments/:id' do
    halt redirect to('/login') unless session[:isLogin]
    comment = Comment.get(params[:id])
    comment.destroy if comment
    redirect to('/comments')
end



get '/video' do
    @isLogin = session[:isLogin]
    @title = 'Video'
    erb :video
end


# Once request '/login', reset @isFirst true. So in the login page, the msg can not be presented.
get '/login' do
    @isFirst = true
    erb :login
end

post '/login' do 
    if params[:username] == settings.username && params[:password] == settings.password
        session[:isLogin] = true
        redirect to ('/')     
    else
        @msg = 'Wrong username or password, try again.'
        # if username or password not match, set a msg and set @isFirst false
        # so in the login page, the msg can be presented.
        @isFirst = false
        erb :login
    end
end

# clear session
get '/logout' do
    session.clear
    redirect to('/login')
end

# handle 404 error
not_found do
  erb :notfound
end

# handle 500 error and so on
error do 
    erb :error
end

