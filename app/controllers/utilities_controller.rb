class UtilitiesController < ApplicationController

  # Button to clear cache quickly
  def clear_cache
    @result = Rails.cache.clear
  end
  
end
