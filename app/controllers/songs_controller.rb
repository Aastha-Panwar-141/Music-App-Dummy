class SongsController < ApplicationController
    before_action :set_song, only: [:show, :update, :destroy]
    
    # GET /songs
    def index
        songs = Song.all 
        render json: songs
        # render json: {songs: songs}, include: ['song_variants']
    end
    
    # GET /songs/:id
    def show
        # render json: {song: @song}, include: ['song_variants']
        render json: @song
    end
    
    # POST /songs
    def create
        # byebug
        song = Song.new(song_params)
        if song.save
            song.avatar.attach(params[:avatar])
            # render json: song.avatar.attach(params[:avatar])
            render json: {result: "song created successfully!",created_record: song }, status: 201  #created 
        else
            render json: song.errors, status: :unprocessable_entity  #422 status code
        end
    end
    
    # PATCH/PUT /songs/1
    def update
        # byebug
        if @song.update(song_params)
            render json: {result: "song updated successfully!",updated_record: @song}, status: 200
        else
            render json: @song.errors, status: :unprocessable_entity
        end
    end
    
    # DELETE /songs/1
    def destroy
        @song.destroy
        render json: {result: "Record deleted successfully!", deleted_record: @song}
    end
        
    # Use callbacks to share common setup or constraints between actions.
    def set_song
        begin
            @song = Song.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            render json: {result: "No record found for given id."} 
        end
    end
    
    # Only allow a trusted parameter "white list" through.
    def song_params
        params.permit(:vendor_id, :name, :brand_name, :avatar)
    end
end
