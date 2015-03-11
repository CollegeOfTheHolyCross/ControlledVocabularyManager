require 'rails_helper'

RSpec.describe RdfImporter do
  let(:url) { "http://example.com" }
  let(:errors) { ActiveModel::Errors.new(ImportForm.new) }
  let(:importer) { RdfImporter.new(errors) }
  let(:url_to_graph) { double("url_to_graph") }
  let(:graph) { instance_double("RDF::Graph") }
  let(:graph_to_termlist) { double("graph_to_termlist") }
  let(:termlist) { instance_double("ImportableTermList") }
  let(:error_propagator) { class_double("ErrorPropagator") }
  let(:validator_class) { IsValidRdfImportUrl }
  let(:validator) { instance_double("IsValidRdfImportUrl") }

  before do
    allow(importer).to receive(:url_to_graph).and_return(url_to_graph)
    allow(url_to_graph).to receive(:call).with(url).and_return(graph)
    allow(graph).to receive(:empty?).and_return(false)

    allow(importer).to receive(:graph_to_termlist).and_return(graph_to_termlist)
    allow(graph_to_termlist).to receive(:call).with(graph).and_return(termlist)
    allow(termlist).to receive(:valid?).and_return(true)

    allow(importer).to receive(:error_propagator).and_return(error_propagator)
    allow(error_propagator).to receive(:call)

    allow(importer).to receive(:validators).and_return([validator_class])
    allow(validator_class).to receive(:new).and_return(validator)
    allow(validator).to receive(:validate).with(importer)

    expect(importer).not_to receive(:injector)
  end

  describe "#call" do
    context "when there are no errors" do
      it "should set the term_list" do
        importer.call(url)
        expect(importer.term_list).to eq(termlist)
      end

      it "should call the error propagator on the termlist" do
        expect(error_propagator).to receive(:call).with(termlist, errors, :limit => 10)
        importer.call(url)
      end
    end

    context "when there's an error in the validator" do
      before do
        expect(validator).to receive(:validate).with(importer) { errors.add(:base, "validator error") }
      end

      it "shouldn't call url_to_graph" do
        expect(url_to_graph).not_to receive(:call)
        importer.call(url)
      end

      it "shouldn't call graph_to_termlist" do
        expect(graph_to_termlist).not_to receive(:call)
        importer.call(url)
      end
    end

    context "when an empty graph is returned" do
      before do
        expect(url_to_graph).to receive(:call).with(url).and_return(graph)
        expect(graph).to receive(:empty?).and_return(true)
      end

      it "should add an error" do
        importer.call(url)
        expect(importer.errors.count).to eq(1)
        expect(importer.errors[:url]).to eq(["must resolve to valid RDF"])
      end

      it "shouldn't call graph_to_termlist" do
        expect(graph_to_termlist).not_to receive(:call)
        importer.call(url)
      end
    end
  end
end
