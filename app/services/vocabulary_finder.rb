class VocabularyFinder
  def self.call
    sparql = ActiveTriples::Repositories.repositories[Vocabulary.repository].query_client

    result = sparql.query("select * where {
	?s ?p ?o
	filter(regex(str(?s), 'http://opaquenamespace.org/ns'))}")

    puts result.inspect
  end

  def base_uri
   return "http://opaquenamespace.org/ns"
  end

  def type
   return "http://purl.org/dc/dcam/VocabularyEncodingScheme"
  end
end
