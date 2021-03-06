require 'rails_helper'

RSpec.describe "vocabularies/index.html.erb" do
  let(:vocabs) { [vocabulary] }
  let(:vocabulary) { Vocabulary.new("bla") }
  before do
    assign(:vocabularies, vocabs)
    render
  end
  it "should display all vocabularies" do
    expect(rendered).to have_link(vocabulary.rdf_subject.to_s, :href => term_path(:id => vocabulary.id))
  end
  it "should display a link to create a new vocabulary" do
    expect(rendered).to have_link "Create Vocabulary", :href => "/vocabularies/new"
  end
end
