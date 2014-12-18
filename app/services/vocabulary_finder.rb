class VocabularyFinder
  def self.call
    ActiveTriples::Repositories.repositories[Vocabulary.repository].query_client.query("select ?resource where {
 	rdf:type ?rdf_type
	filter strstarts(str(?resource), $base_uri)
	}").dump
  end

  def base_uri
   return Vocabulary.base_uri
  end

  def rdf_type
   return "http://purl.org/dc/dcam/VocabularyEncodingScheme"
  end
end
