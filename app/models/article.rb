require 'elasticsearch/model'
class Article < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :title, analyzer: 'english'
      indexes :text, analyzer: 'english'
      indexes :suggest, {
        type: 'completion',
        analyzer: 'simple',
        search_analyzer: 'simple'
      }
    end
  end

  def self.quick_search(query)
    __elasticsearch__.search(
      {
        query: {
          bool: {
            should: [
              {
                wildcard: {title: "*#{query}*"}
              },
              {
                wildcard: {text: "*#{query}*"}
              },
              {
                multi_match: {
                  query: query,
                  fields: ["title", "text"]
                }
              }
            ]
          }
        },
        highlight: {
          pre_tags: ['<em>'],
          post_tags: ['</em>'],
          fields: {
            title: {},
            text: {}
          }
        }
      }
    )
  end

  def as_indexed_json(_options = {})
    {
      title: title,
      text: text,
      suggest: {
        input: [title]
      },
    }
  end


  def self.auto_complete(query)

    return nil if query.blank?

    search_definition = {
      'suggest' => {
        'name-suggest' => {
          text: query,
          completion: {
            field: 'suggest'
          }
        }
      }
    }

    __elasticsearch__.client.perform_request('GET', "#{index_name}/_search", {}, search_definition).body['suggest']['name-suggest'].first['options']
  end
end
