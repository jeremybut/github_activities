class SearchesController < ApplicationController
  respond_to :js

  def saved_searches
    @saved_searches = Search.saved_searches
  end

end
