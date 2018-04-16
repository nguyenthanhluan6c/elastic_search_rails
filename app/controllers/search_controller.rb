class SearchController < ApplicationController
  def quick_search
    @articles = if params[:query].blank?
      []
    else
      Article.search( params[:query] )
    end
  end

  def search
    if params[:term].nil?
      @articles = []
    else
      @articles = Article.quick_search params[:term]
    end
  end

  def suggest
    result = Article.auto_complete(params[:term]).map do |article|
      {title: article["_source"]["title"], value: article["_source"]["id"]}
    end
    render json: result
  end

  def misspellings

  end
end
