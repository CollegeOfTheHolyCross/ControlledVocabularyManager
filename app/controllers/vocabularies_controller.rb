class VocabulariesController < ApplicationController
  before_filter :load_vocab, :only => :show
  delegate :term_form, :sparql_client, :all_vocabs_query, :to => :injector
  skip_before_filter :check_auth, :only => [:index]

  def index
    @vocabularies = all_vocabs_query.call
  end

  def new
    @vocabulary = term_form
  end

  def create
    if term_form.save
      redirect_to term_path(:id => term_form.term_id)
    else
      @vocabulary = term_form
      render "new"
    end
  end

  private

  def injector
    @injector ||= VocabularyInjector.new(params)
  end
end
