require 'securerandom'

class ClocksController < ApplicationController
  before_action :set_clock, only: [:show, :update]

  # GET /123401230h10101gh1ghg10
  # GET /123401230h10101gh1ghg10.json
  def show
    @clock.updateTimeLeft()
  end

  # POST /clocks
  # POST /clocks.json
  def create
    @clock = Clock.new(default_params())

    respond_to do |format|
      if @clock.save
        format.html { redirect_to key_view_clock_url(@clock.key), notice: 'Clock was successfully created.' }
        format.json { render action: 'show', status: :created, location: @clock }
      else
        format.html { redirect_to root_url }
        format.json { render json: @clock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clocks/1
  # PATCH/PUT /clocks/1.json
  def update

    @clock.updateTimeLeft()
    hash = clock_params
    hash[:player_one_time] = hash[:new_player_one_time] if hash[:new_player_one_time]
    hash[:player_two_time] = hash[:new_player_two_time] if hash[:new_player_two_time]
    hash.delete("new_player_one_time")
    hash.delete("new_player_two_time")
    puts hash
    @clock.assign_attributes hash

    respond_to do |format|
      if @clock.save
        format.html { redirect_to key_view_clock_url @clock.key, notice: 'Clock was successfully updated.' }
        format.json { render json: @clock }
      else
        format.html { render action: 'edit' }
        format.json { render json: @clock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clocks/1
  # DELETE /clocks/1.json
  def destroy
    @clock.destroy
    respond_to do |format|
      format.html { redirect_to clocks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clock
      @clock = Clock.where(key: params[:key]).take if params[:key]
      @clock = Clock.find(params[:id]) if !@clock and params[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clock_params
      params.permit(:active, :current_player, :new_player_one_time, :new_player_two_time, :key)
    end

    def default_params
      {:active => false, :current_player => 1, :player_one_time => 60, :player_two_time => 60, :key => SecureRandom.hex[0..4]}
    end
end
