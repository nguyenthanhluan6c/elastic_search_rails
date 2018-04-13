require 'elasticsearch/model'

class Person < ApplicationRecord
  # include elasticsearch
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  # define elasticsearch index and type for model
  index_name  'es_demo_people'
  document_type 'person'

  # custom elasticsearch mapping per autocompletion
  mapping do
    indexes :name, type: 'text'
    indexes :suggest, {
      type: 'completion',
      analyzer: 'simple',
      search_analyzer: 'simple'
    }
  end

  # simple model validation
  validates :first_name, presence: true
  validates :last_name, presence: true

  # instance method to determine how models are indexed in elasticsearch
  def as_indexed_json(_options = {})
    {
      name: "#{first_name} #{last_name}",
      suggest: {
        input: [first_name, last_name],
      },
    }
  end

  # class method to execute autocomplete search
  def self.auto_complete(q)
    return nil if q.blank?

    search_definition = {
      'suggest' => {
        'name-suggest' => {
          text: q,
          completion: {
            field: 'suggest',
            fuzzy: {
              fuzziness: 2
            }
          }
        }
      }
    }

    # self.search(search_definition)
    # __elasticsearch__.client.suggest index: index_name, body: search_definition
    __elasticsearch__.client.perform_request('GET', "#{index_name}/_search", {}, search_definition).body['suggest']['name-suggest'].first['options']
  end

end
