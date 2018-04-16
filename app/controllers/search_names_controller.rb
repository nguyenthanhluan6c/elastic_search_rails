class SearchNamesController < ApplicationController
  def search
    if params[:name_term].nil?
      @people = []
    else
      @people = Person.search params[:name_term]
    end
  end

  def misspellings
    result = Person.auto_complete(params[:name_term]).map do |person|
      {name: person["_source"]["name"], value: person["_source"]["id"]}
    end
    render json: result
  end
end
