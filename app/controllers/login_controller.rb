class LoginController < ApplicationController
  
  def doauth
	
  if session[:authorized] != true
  	authenticate
  	authorize
  	
  else
   destroy
  end
  	
  end
  
  

  def authenticate
    unless github_authenticated?
      github_authenticate!
  	end
  	
  end


  def authorize
    session[:authorized] ||= github_user.organization_member?('OregonDigital')
    logger.debug "session var is set #{session[:authorized]}"
    logger.debug "user is #{github_user.name}"
   # render :status => 403, :text => "Not Authorized" unless session[:authorized] != true
    if session[:authorized] != true
      flash.keep[:notice] = "authorization failed"
    #else flash.keep[:notice]= "#{github_user.name} is logged in " 
    end
    redirect_to '/'
  end
  
   def destroy
   	
    github_logout
    session[:authorized] = false
    flash[:notice]= "You have logged out"
    redirect_to '/'
    
  end
  
end
