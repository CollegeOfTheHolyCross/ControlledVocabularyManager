require 'json/ld'

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

  class CreateResponder < SimpleDelegator
    def success(vocabulary)
      redirect_to term_path(vocabulary)
    end

    def failure(vocabulary)
      __getobj__.instance_variable_set(:@vocabulary, vocabulary)
      render :new
    end
    
    def authorize
    if session[:authorized] != true
      flash[:notice] = "Not authorized for this page."
      redirect_to '/'
  	
  	end
  end
  end
end
