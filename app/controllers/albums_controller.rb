class AlbumsController < ApplicationController
  before_action :set_album, only: %i[ show edit update destroy ]

  PAGE_SIZE = 16

  # GET /albums or /albums.json
  def index
    offset = albums_params[:page] ? (albums_params[:page].to_i - 1) * PAGE_SIZE : 0
    order_clauses = {
      'artist' => 'artists.name',
      'artist_d' => 'artists.name DESC',
      'album' => 'albums.name',
      'album_d' => 'albums.name DESC',
    }

    query = 'Album'
    query << '.joins(:artist)' if albums_params['order_by'] && order_clauses[albums_params['order_by']]
    query << '.where("albums.name ILIKE ?", "%#{albums_params[:search]}%")' if albums_params[:search]
    query << '.order(order_clauses[albums_params[:order_by]])' if albums_params['order_by'] && order_clauses[albums_params['order_by']]
    query << '.limit(PAGE_SIZE)'
    query << '.offset(offset)'
    
    @albums = eval(query)
  end

  # GET /albums/1 or /albums/1.json
  def show
  end

  # GET /albums/new
  def new
    raise ActionController::RoutingError.new('Not Found') unless current_user&.role == 'admin'

    @album = Album.new
  end

  # GET /albums/1/edit
  def edit
    raise ActionController::RoutingError.new('Not Found') unless current_user&.role == 'admin'
  end

  # POST /albums or /albums.json
  def create
    raise ActionController::RoutingError.new('Not Found') unless current_user&.role == 'admin'

    artist = Artist.find_or_create_by(name: album_params['artist_name'])

    @album = Album.new({
      'name' => album_params['name'],
      'artist_id' => artist.id,
    })

    respond_to do |format|
      if @album.save
        format.html { redirect_to album_url(@album), notice: "Album was successfully created." }
        format.json { render :show, status: :created, location: @album }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1 or /albums/1.json
  def update
    raise ActionController::RoutingError.new('Not Found') unless current_user&.role == 'admin'
    
    artist = Artist.find_or_create_by(name: album_params['artist_name'])

    album_and_artist_params = {
      'name' => album_params['name'],
      'artist_id' => artist.id,
    }

    respond_to do |format|
      if @album.update(album_and_artist_params)
        format.html { redirect_to album_url(@album), notice: "Album was successfully updated." }
        format.json { render :show, status: :ok, location: @album }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1 or /albums/1.json
  def destroy
    raise ActionController::RoutingError.new('Not Found') unless current_user&.role == 'admin'
    
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url, notice: "Album was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def page_size
    PAGE_SIZE
  end

  def albums_params
    params.permit(:order_by, :page, :search)
  end

  # Expose variables / methods to the view
  helper_method :page_size
  helper_method :albums_params

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def album_params
      params.require(:album).permit(:name, :artist_name)
    end
end
