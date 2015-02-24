require 'rails_helper'

RSpec.describe TermWithChildren do
  let(:vocabulary) { Vocabulary.new(uri) }
  let(:uri) { "http://opaquenamespace.org/ns/bla" }
  subject { TermWithChildren.new(vocabulary) }

  describe "#children" do
    let(:result) { subject.children }
    context "with no children exist" do
      it "should return nothing" do
        expect(subject.children).to eq []
      end
    end
    context "with children" do
      let(:child) { Term.new(uri+"/1") }
      let(:child_2) { Term.new(uri+"q/2") }
      before do
        child.persist!
        child_2.persist!
      end
      it "should return children" do
        expect(subject.children).to eq [child]
      end
    end
  end
end
