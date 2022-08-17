class AlbumsController < ApplicationController
  before_action :set_album, only: %i[ show edit update destroy ]

  # GET /albums or /albums.json
  def index
    @albums = Album.all
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
