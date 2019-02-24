class Admin::GeographiesController < Admin::BaseController

  before_action :set_geography, only: [:show, :edit, :update, :destroy, :set_preview_geography]
  before_action :set_headings, only: [:new, :edit, :update, :create]
  before_action :set_preview_geography, only: :preview_polygon

  respond_to :html, :js

  def index
    @geographies = Geography.all.order("LOWER(name)")
  end

  def new
    @geography = Geography.new
  end

  def edit
  end

  def create
    @geography = Geography.new(geography_params)

    if @geography.save
      redirect_to admin_geographies_path, notice: "Geography was successfully created."
    else
      render :new
    end
  end

  def update
    if @geography.update(geography_params)
      redirect_to admin_geographies_path, notice: "Geography was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @geography.destroy
    redirect_to admin_geographies_path, notice: t("admin.geographies.delete.success")
  end

  def preview_polygon
    geojson_data = params['geojson']

    @preview_geography.geojson = geojson_data

    respond_to do |format|
      if not @preview_geography.valid?
        format.js { render 'redlight_geojson_field.js.erb', layout: false,
                    content_type: 'text/javascript'}
      end
    end
  end

  private

  def set_geography
    @geography = Geography.find(params[:id])
  end

  def set_headings
    @headings = Budget::Heading.order(:name)
  end

  def geography_params
    params.require(:geography).permit(:name, :color, :geojson, heading_ids: [])
  end

  def set_preview_geography
    @preview_geography = Geography.new(name: "Preview Geography", color: "#1c6b93")
  end

end
