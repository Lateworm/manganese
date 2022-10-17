class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]

  PAGE_SIZE = 16

  # GET /events or /events.json
  def index
    offset = events_params[:page] ? (events_params[:page].to_i - 1) * PAGE_SIZE : 0
    order = events_params['order_by'] && order_clauses[events_params['order_by']] ? events_params['order_by'] : 'date_desc'

    order_clauses = {
      'artist' => 'events.name',
      'artist_d' => 'events.name DESC',
      'date_desc' => 'events.started_at DESC',
    }

    query = 'Event'
    query << '.where("events.name ILIKE ?", "%#{events_params[:search]}%")' if events_params[:search]
    query << '.order(order_clauses[order])'
    query << '.limit(PAGE_SIZE)'
    query << '.offset(offset)'

    @events = eval(query)
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def page_size
    PAGE_SIZE
  end

  def events_params
    params.permit(:order_by, :page, :search)
  end

  # Expose variables / methods to the view
  helper_method :page_size
  helper_method :events_params

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :started_at)
    end
end
