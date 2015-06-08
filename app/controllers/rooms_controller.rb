class RoomsController < ApplicationController
	before_action :config_opentok
	before_filter :config_opentok,:except => [:index]
	def index
		@rooms = Room.where(:public => true).order('created_at DESC')
		@new_room = Room.new
	end

	def create
		session = @opentok.create_session
		params[:room][:sessionId] = session.session_id
		# render :json => new_room_params
		@new_room = Room.new(new_room_params)

		respond_to do |format|
			if @new_room.save
				format.html { redirect_to('/party/'+@new_room.id.to_s) }
			else
				format.html { render :controller => 'rooms',
				:action => 'index' }
			end
		end
	end

	def party
		@room = Room.find(params[:id])
		# render :json => @room
		@tok_token = @opentok.generate_token @room.sessionId 
	end

	def archive
		 # logger.debug "arams"
		# 
		if request.xhr?
        	archive = opentok.archives.create params[:sessionId]
     	end
	end

	def disconnect

	end

	private
	def config_opentok
		if @opentok.nil?
			@opentok = OpenTok::OpenTok.new '45253112', '989f43ac66fdf6688f1b9719168ee8292d3ce153'
		end
	end

	def new_room_params
    	params.require(:room).permit(:name, :public, :sessionId )
  	end

end
