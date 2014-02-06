class HomeController < ActionController::Base
  protect_from_forgery
  
   def index   
   	session[:oauth] = Koala::Facebook::OAuth.new(APP_ID, APP_SECRET, SITE_URL + 'home/callback')
		@auth_url =  session[:oauth].url_for_oauth_code(:permissions=>["read_stream","user_likes","user_friends","friends_likes","friends_birthday","friends_about_me","friends_relationships","friends_interests","friends_activities","friends_location","friends_status"]) 
		puts session.to_s + "<<< session"

  	respond_to do |format|
			 format.html {  }
		 end
  end

	def callback
  	if params[:code]
  		# acknowledge code and get access token from FB
		session[:access_token] = session[:oauth].get_access_token(params[:code])
	end		

		 # auth established, now do a graph call:
		  
		@api = Koala::Facebook::API.new(session[:access_token])
		begin
			mysex =  @api.get_object("/me?fields=gender")
			mydata =  @api.get_object("/me?fields=id,first_name,last_name")
			
			#if !User.exists?(idfacebook: mydata["id"])
			#	@user = User.new( idfacebook: mydata["id"], first_name: mydata["first_name"], last_name: mydata["last_name"] )
			#	@user.save
			#else
			#	@user = User.find_by idfacebook: mydata["id"]
			#end
				
			sexinterest = ""
			case mysex["gender"]
				when "male" then sexinterest="female"
				else sexinterest="male"
			end
			@graph_data = @api.fql_query('SELECT uid,first_name,last_name, relationship_status, birthday_date, about_me, pic_small from user where uid in (SELECT uid2 FROM friend WHERE uid1 = me()) and (relationship_status="Single" or relationship_status="Widowed" or relationship_status="Divorced" or relationship_status="Separated") and sex="'+sexinterest+'"  ORDER BY first_name')
			#@graph_data.each do |friend|	
			#	if !Friend.where(first_name: friend["first_name"], last_name: friend["last_name"], user_id: @user.id).exists?		
			#		@friend = Friend.new( idfacebook: friend["uid"], first_name: friend["first_name"], last_name: friend["last_name"],
			#		user_id: @user.id )
			#		@friend.save
			#	end
			#end

		rescue Exception=>ex
			puts ex.message
		end
		
  
 		respond_to do |format|
		 format.html {   }			 
		end
		
	
	end

	def getdata
		@id = params[:id]

		@api = Koala::Facebook::API.new(session[:access_token])
		@mylikes = @api.fql_query('SELECT page_id,name from page where page_id in (SELECT page_id from page_fan where uid=me())')
		@datafriend = @api.fql_query('select name,about_me,activities, interests,current_location,pic,profile_url,status,friend_count from user where uid='+@id+'')
		@likesfriend = @api.fql_query('SELECT page_id,name from page where page_id in (SELECT page_id from page_fan where uid='+@id+')')
	end
end

