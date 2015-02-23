require 'rails_helper'

RSpec.describe TermsController do
  let(:uri) { "http://opaquenamespace.org/ns/bla" }
  let(:resource) { term_mock }

  describe '#show' do
    before do
      stub_repository
      allow(resource).to receive(:dump)
      allow(Term).to receive(:find).with("bla").and_return(resource)
    end

    context "when the resource exists" do
      let(:format) {}
      before do
        allow(resource).to receive(:persisted?).and_return(true)
        get :show, :id => resource.id, :format => format
      end

      it "should render the show template" do
        expect(response).to render_template("show")
      end
      
      context "format html" do
        it "should render html" do
          expect(response.content_type).to eq("text/html")
        end
      end

      context "format n-triples" do
        let(:format) {:nt}
        it "should render n-triples" do
          expect(response.content_type).to eq("application/n-triples")
          expect(resource).to have_received(:dump).with(:ntriples)
        end
      end

      context "format json-ld" do
        let(:format) {:jsonld}
        it "should render json-ld" do
          expect(response.content_type).to eq("application/ld+json")
          expect(resource).to have_received(:dump).with(:jsonld, {:standard_prefixes => true})
        end
      end
    end

    context "when the resource does not exist" do
      before do
        allow(Term).to receive(:find).with("nothing").and_raise ActiveTriples::NotFound
        get :show, :id => "nothing"
      end

      it "should return a 404" do
        expect(response.status).to eq 404
      end
    end
  end
  describe "GET new" do
    let(:vocabulary) { vocabulary_mock }
    let(:persisted_status) { true }
    let(:term) { term_mock }
    before do
      allow(Vocabulary).to receive(:find).with(vocabulary.id).and_return(vocabulary)
      allow(vocabulary).to receive(:persisted?).and_return(persisted_status)
      allow(Term).to receive(:new).with(no_args).and_return(term)
    end
    def get_new
      get :new, :vocabulary_id => vocabulary.id
    end
    context "when the vocabulary is not persisted" do
      before do
        expect(Vocabulary).to receive(:find).with(vocabulary.id).and_raise ActiveTriples::NotFound
      end
      it "should raise a 404" do
        expect(get_new.code).to eq "404"
      end
    end
    context "when the vocabulary is persisted" do
      before do
        get_new
      end
      it "should assign @vocabulary" do
        expect(assigns(:vocabulary)).to eq vocabulary
      end
      it "should assign @term" do
        expect(assigns(:term)).to eq term
      end
      it "should render new" do
        expect(response).to render_template("new")
      end
    end
  end

  describe "POST create" do
    let(:vocabulary) { vocabulary_mock }
    let(:term) { term_mock }
    let(:params) do
      {
        :vocabulary_id => vocabulary.id,
        :term => {
          :id => "test",
          :comment => ["Test"],
          :label => ["Label"]
        }
      }
    end
    let(:create_responder) { instance_double(TermsController::CreateResponder) }
    before do
      allow(Vocabulary).to receive(:find).with(vocabulary.id).and_return(vocabulary)
      allow(TermCreator).to receive(:call) do
        controller.render :nothing => true
      end
    end
    it "should call TermCreator" do
      expect(TermsController::CreateResponder).to receive(:new).with(controller).and_return(create_responder)
      expect(TermCreator).to receive(:call).with(params[:term], vocabulary, [create_responder])
      post :create, params
    end
    context "when vocabulary isn't found" do
      before do
        allow(Vocabulary).to receive(:find).and_raise ActiveTriples::NotFound
      end
      it "should return a 404" do
        expect(post(:create, params).code).to eq "404"
      end
      it "doesn't call TermCreator" do
        expect(TermCreator).not_to receive(:call)
        post :create, params
      end
    end
    describe "CreateResponder" do
      let(:term) { Term.new }
      let(:term_id) { "bla/bla" }
      describe "#success" do
        before do
          allow(controller).to receive(:create) do
            TermsController::CreateResponder.new(controller).success(term, vocabulary)
          end
          allow(term).to receive(:persisted?).and_return(true)
          allow(term).to receive(:id).and_return(term_id)
          post :create, params
        end
        it "should redirect to the term" do
          expect(response).to redirect_to("/ns/#{term_id}")
        end
      end
      describe "#failure" do
        before do
          allow(controller).to receive(:create) do
            TermsController::CreateResponder.new(controller).failure(term, vocabulary)
          end
          post :create, params
        end
        it "should render new template" do
          expect(response).to render_template("new")
        end
        it "should assign @vocabulary" do
          expect(assigns(:vocabulary)).to eq vocabulary
        end
        it "should assign @term" do
          expect(assigns(:term)).to eq term
        end
      end
    end
  end
end
