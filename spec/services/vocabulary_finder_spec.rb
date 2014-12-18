require 'rails_helper'

RSpec.describe VocabularyFinder do
  describe ".call" do
    let(:result) { VocabularyFinder.call }
    context "when there are vocabulary objects" do
      let(:vocab_1) { Vocabulary.new("first") }
      let(:vocab_2) { Vocabulary.new("second") }
      before do
        vocab_1.persist!
        vocab_2.persist!
      end
      it "should return them" do
        expect(result.map(&:rdf_subject)).to eq [vocab_1.rdf_subject, vocab_2.rdf_subject]
        expect(result.map(&:class)).to eq [Vocabulary, Vocabulary]
      end
    end
    context "when there are CV objects" do
      let(:vocab) { ControlledVocabulary.new("first") }
      before do
        vocab.persist!
      end
      it "should not return them" do
        expect(result).to be_empty
      end
    end
  end
end
