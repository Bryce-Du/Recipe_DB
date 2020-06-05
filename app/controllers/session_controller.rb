class SessionController < ApplicationController
    get "/signup" do
        erb :'sessions/signup'
    end
    post "/signup" do
        if params[:user]["username"] == "admin"
            @error = "Invalid Username, please try again."
            erb :'sessions/signup'
        elsif params[:user]["password"].size < 8 
            @error = "Password too short, please try again."
            erb :'sessions/signup'
        else
            user = User.create(params[:user])
            session[:user_id] = user.id
            redirect to "/"
        end
    end
    get "/login" do
        erb :"/sessions/login"
    end
    post "/login" do 
        user = User.find_by(username: params[:user]["username"])
        if user.authenticate(params[:user]["password"])
            session[:user_id] = user.id
            redirect to "/"
        else
            @error = "Invalid Credentials, please try again."
            erb :"sessions/login"
        end
    end
    get "/logout" do
        session.destroy
        redirect to "/"
    end
end