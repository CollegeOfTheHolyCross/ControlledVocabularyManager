class VocabulariesController < ApplicationController
  before_filter :load_vocab, :only => :show
  before_filter :authorize, :only => [:new, :create]
  def index
  end

  def new
    @vocabulary = Vocabulary.new
  end

  def create
    VocabularyCreator.call(params[:vocabulary], CreateResponder.new(self))
  end


  def authorize
    if session[:authorized] != true
    session[:user_route] = request.env['PATH_INFO']
    
    redirect_to '/login'
      
  	end
  end
  	
  class CreateResponder < SimpleDelegator
    def success(vocabulary)
      redirect_to term_path(vocabulary)
    end

    def failure(vocabulary)
      __getobj__.instance_variable_set(:@vocabulary, vocabulary)
      render :new
    end
    
    
  end

end
