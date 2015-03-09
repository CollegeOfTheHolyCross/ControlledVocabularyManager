require 'rails_helper'

RSpec.describe AllVocabsQuery do
  describe ".call" do
    context "when vocabularies exist" do
      before do
        stub_repository
      end
      let(:vocabulary) { SetsIssued.new(Vocabulary.new("bla")) }
      let(:sparql_client) { vocabulary.repository.query_client }
      let(:repository) { VocabularyInjector.new.vocabulary_repository }
      before do
        vocabulary.label = "YO"
        vocabulary.persist!
      end
      it "should return all vocabularies" do
        expect(described_class.call(sparql_client, repository)).to eq [vocabulary.__getobj__]
      end
      it "should not return terms" do
        repository.new("2/1").persist!
        expect(described_class.call(sparql_client, repository)).to eq [vocabulary.__getobj__]
      end
    end
  end
end
