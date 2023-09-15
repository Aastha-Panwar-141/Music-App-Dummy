class PlaylistsController < ApplicationController
    before_action :set_playlist, only: [:show, :update, :destroy]
    
    # GET /playlists
    def index
        playlists = Playlist.all 
        render json: playlists
        # render json: {playlists: playlists}, include: ['playlist_variants']
    end
    
    # GET /playlists/:id
    def show
        # render json: {playlist: @playlist}, include: ['playlist_variants']
        render json: @playlist
    end
    
    # POST /playlists
    def create
        # byebug
        playlist = Playlist.new(playlist_params)
        if playlist.save
            playlist.avatar.attach(params[:avatar])
            # render json: playlist.avatar.attach(params[:avatar])
            render json: {result: "playlist created successfully!",created_record: playlist }, status: 201  #created 
        else
            render json: playlist.errors, status: :unprocessable_entity  #422 status code
        end
    end
    
    # PATCH/PUT /playlists/1
    def update
        # byebug
        if @playlist.update(playlist_params)
            render json: {result: "playlist updated successfully!",updated_record: @playlist}, status: 200
        else
            render json: @playlist.errors, status: :unprocessable_entity
        end
    end
    
    # DELETE /playlists/1
    def destroy
        @playlist.destroy
        render json: {result: "Record deleted successfully!", deleted_record: @playlist}
    end
        
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
        begin
            @playlist = playlist.find(params[:id])
        rescue ActiveRecord::RecordNotFound
            render json: {result: "No record found for given id."} 
        end
    end
    
    # Only allow a trusted parameter "white list" through.
    def playlist_params
        params.permit(:title, :listener_id)
    end
end
