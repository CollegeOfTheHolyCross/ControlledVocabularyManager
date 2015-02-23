class LoginController < ApplicationController
  
  def doauth
  #logger.debug "session var: #{session[:authorized]}"
  if session[:authorized] != true
  	authenticate
  	authorize
  	
  else
   destroy
  end
  	
  end
  
  

  def authenticate
    unless github_authenticated?
      flash.now[:notice] = "Please log in." #this is not working
      github_authenticate!
  	end
  	
  end


  def authorize
    session[:authorized] ||= github_user.organization_member?('OregonDigital')
    #logger.debug "session var is set #{session[:authorized]}"
    #logger.debug "user is #{github_user.name}"
    if session[:authorized] != true
      flash.keep[:notice] = "authorization failed"
    #else flash.keep[:notice]= "#{github_user.name} is logged in " 
    end
   session[:user_route] ||= "/"
    redirect_to session[:user_route]
  end
  
   def destroy
   	#logger.debug "logging out"
    github_logout
    session[:authorized] = false
    
    redirect_to '/', notice: "You have logged out"
    
  end
  
end
