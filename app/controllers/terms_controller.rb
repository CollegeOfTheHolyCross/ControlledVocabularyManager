class TermsController < ApplicationController
  delegate :term_form, :edit_term_form, :term_repository, :vocabulary_repository, :to => :injector
  rescue_from ActiveTriples::NotFound, :with => :render_404
  skip_before_filter :check_auth, :only => [:show]

  def show
    @term = find_term

    respond_to do |format|
      format.html
      format.nt { render body: @term.full_graph.dump(:ntriples), :content_type => Mime::NT }
      format.jsonld { render body: @term.full_graph.dump(:jsonld, standard_prefixes: true), :content_type => Mime::JSONLD }
    end
  end

  def new
    @term = term_form
    @vocabulary = find_vocabulary
  end

  def create
    @vocabulary = find_vocabulary

    if term_form.save
      redirect_to term_path(:id => term_form.id)
    else
      @term = term_form
      render "new"
    end
  end

  def edit
    @term = edit_term_form
  end

  def update
    if edit_term_form.save
      redirect_to term_path(:id => params[:id])
    else
      @term = edit_term_form
      render "edit"
    end
  end


  private

  def injector
    @injector ||= TermInjector.new(params)
  end

  def find_term
    term_repository.find(params[:id])
  end

  def find_vocabulary
    vocabulary_repository.find(params[:vocabulary_id])
  end

  def render_404
    respond_to do |format|
      format.html { render "terms/404", :status => 404 }
      format.all { render nothing: true, status: 404 }
    end
  end

  def vocabulary
    @vocabulary ||= Vocabulary.find(params[:vocabulary_id])
  end

end
