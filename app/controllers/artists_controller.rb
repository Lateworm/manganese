class ArtistsController < ApplicationController
  before_action :set_artist, only: %i[ show edit update destroy ]

  PAGE_SIZE = 16

  # GET /artists or /artists.json
  def index
    offset = artists_params[:page] ? (artists_params[:page].to_i - 1) * PAGE_SIZE : 0 
    order_clauses = {
      'artist' => 'artists.name',
      'artist_d' => 'artists.name DESC',
    }

    query = 'Artist'
    query << '.where("artists.name ILIKE ?", "%#{artists_params[:search]}%")' if artists_params[:search]
    query << '.order(order_clauses[artists_params[:order_by]])' if artists_params['order_by'] && order_clauses[artists_params['order_by']]
    query << '.limit(PAGE_SIZE)'
    query << '.offset(offset)'

    @artists = eval(query)
  end

  # GET /artists/1 or /artists/1.json
  def show
  end

  # GET /artists/new
  def new
    raise ActionController::RoutingError.new('Not Found') unless current_user&.role == 'admin'

    @artist = Artist.new
  end

  # GET /artists/1/edit
  def edit
    raise ActionController::RoutingError.new('Not Found') unless current_user&.role == 'admin'
  end

  # POST /artists or /artists.json
  def create
    raise ActionController::RoutingError.new('Not Found') unless current_user&.role == 'admin'

    @artist = Artist.new(artist_params)

    respond_to do |format|
      if @artist.save
        format.html { redirect_to artist_url(@artist), notice: "Artist was successfully created." }
        format.json { render :show, status: :created, location: @artist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /artists/1 or /artists/1.json
  def update
    raise ActionController::RoutingError.new('Not Found') unless current_user&.role == 'admin'

    respond_to do |format|
      if @artist.update(artist_params)
        format.html { redirect_to artist_url(@artist), notice: "Artist was successfully updated." }
        format.json { render :show, status: :ok, location: @artist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @artist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /artists/1 or /artists/1.json
  def destroy
    raise ActionController::RoutingError.new('Not Found') unless current_user&.role == 'admin'
    
    @artist.destroy

    respond_to do |format|
      format.html { redirect_to artists_url, notice: "Artist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def page_size
    PAGE_SIZE
  end

  def artists_params
    params.permit(:order_by, :page, :search)
  end

  # Expose variables / methods to the view
  helper_method :page_size
  helper_method :artists_params

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_artist
      @artist = Artist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def artist_params
      params.require(:artist).permit(:name)
    end
end
