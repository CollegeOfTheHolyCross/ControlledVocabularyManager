require 'rails_helper'

describe ControlledVocabulary do
  it "should be an AT::Resource" do
    expect(ControlledVocabulary < ActiveTriples::Resource).to be true
  end
end
