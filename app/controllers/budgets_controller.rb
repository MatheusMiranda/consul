class BudgetsController < ApplicationController
  NEW_YORK_LATITUDE = 40.730610
  NEW_YORK_LONGITUDE = -73.935242

  include FeatureFlags
  include BudgetsHelper
  feature_flag :budgets

  load_and_authorize_resource
  before_action :set_default_budget_filter, only: :show
  before_action :create_map_Location, only: :index
  has_filters %w{not_unfeasible feasible unfeasible unselected selected}, only: :show

  respond_to :html, :js

  def show
    raise ActionController::RoutingError, 'Not Found' unless budget_published?(@budget)
  end

  def index
    @finished_budgets = @budgets.finished.order(created_at: :desc)
    @budgets_coordinates = current_budget_map_locations
    @banners = Banner.in_section('budgets').with_active
    @geographies_coordinates = Geography.all.map{ |g| { outline_points: g.outline_points, heading_id: g.heading_id} }
  end

  def create_map_Location
    @map_location = MapLocation.new
    #@map_location.zoom = OSM_DISTRICT_LEVEL_ZOOM
    @map_location.latitude = NEW_YORK_LATITUDE
    @map_location.longitude = NEW_YORK_LONGITUDE
  end

end
