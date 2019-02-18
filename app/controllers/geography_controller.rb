class GeographiesController < ApplicationController

  before_action :set_preview_geography, only: :preview_polygon

  def preview_polygon

  end

  private

  def set_preview_geography
    @preview_geography = Geography.new(name: "Preview Geography", color: "#1c6b93")
  end

end
