class VocabularyFinder
  def self.call
    ActiveTriples::Repositories.repositories[Vocabulary.repository].query_client.query("select distinct ?resource where {
	?resource rdf:type $type
	filter strstarts(str(?resource), $base_uri)}")
  end

  def base_uri
   return Vocabulary.base_uri
  end

  def type
   return "http://purl.org/dc/dcam/VocabularyEncodingScheme"
  end
end
