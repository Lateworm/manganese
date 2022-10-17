class RecommendationsController < ApplicationController
  before_action :set_recommendation, only: %i[ show edit update destroy ]

  PAGE_SIZE = 16

  # GET /recommendations or /recommendations.json
  def index
    offset = params_index[:page] ? (params_index[:page].to_i - 1) * PAGE_SIZE : 0

    query = 'Recommendation'
    query << ".order('recommendations.created_at DESC')"
    # TODO: order by some sort of submitted_at to get better accuracy on imports? Is the data available?
    query << '.limit(PAGE_SIZE)'
    query << '.offset(offset)'

    @recommendations = eval(query)
  end

  # GET /recommendations/1 or /recommendations/1.json
  def show
  end

  # GET /recommendations/new
  def new
    raise ActionController::RoutingError.new('Not Found') unless user_signed_in?
    @recommendation = Recommendation.new
  end

  # GET /recommendations/1/edit
  def edit
    # TODO: Users should be able to edit their own suggestions
    raise ActionController::RoutingError.new('Not Found') unless current_user&.role == 'admin'
  end

  # POST /recommendations or /recommendations.json
  def create
    raise ActionController::RoutingError.new('Not Found') unless user_signed_in?

    artist = Artist.find_or_create_by(name: recommendation_params['artist_name'])
    album = Album.find_or_create_by(name: recommendation_params['album_name'], artist_id: artist.id)

    @recommendation = Recommendation.new({
      'user_id' => current_user.id,
      'album_id' => album.id
    })

    respond_to do |format|
      if @recommendation.save
        format.html { redirect_to recommendation_url(@recommendation), notice: "Recommendation was successfully created." }
        format.json { render :show, status: :created, location: @recommendation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recommendation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recommendations/1 or /recommendations/1.json
  def update
    # TODO: users should be able to update their own recommendations
    raise ActionController::RoutingError.new('Not Found') unless current_user&.role == 'admin'

    artist = Artist.find_or_create_by(name: recommendation_params['artist_name'])
    album = Album.find_or_create_by(name: recommendation_params['album_name'], artist_id: artist.id)

    recommendation_artist_album_params = {
      'user_id' => current_user.id,
      'album_id' => album.id
    }

    respond_to do |format|
      if @recommendation.update(recommendation_artist_album_params)
        format.html { redirect_to recommendation_url(@recommendation), notice: "Recommendation was successfully updated." }
        format.json { render :show, status: :ok, location: @recommendation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recommendation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recommendations/1 or /recommendations/1.json
  def destroy
    raise ActionController::RoutingError.new('Not Found') unless current_user&.role == 'admin'

    @recommendation.destroy

    respond_to do |format|
      format.html { redirect_to recommendations_url, notice: "Recommendation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def page_size
    PAGE_SIZE
  end

  def params_index
    params.permit(:page)
  end

  # Expose variables / methods to the view
  helper_method :page_size
  helper_method :params_index

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_recommendation
      @recommendation = Recommendation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recommendation_params
      params.require(:recommendation).permit(:album_name, :artist_name)
    end
end
