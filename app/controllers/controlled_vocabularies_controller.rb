class ControlledVocabulariesController < ApplicationController
  
  
  
 def show
  end
  
  def index
  authorize
  end
  
  
 
  
  private
  
  def authorize
    if session[:authorized] != true
      flash[:notice] = "Not authorized for this page."
      redirect_to '/'
  	
  	end
  end
  
end
