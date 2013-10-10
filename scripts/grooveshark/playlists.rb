require 'grooveshark'

@client = Grooveshark::Client.new
session = @client.session
begin 
	user = @client.login('ayrton@infogroep.be','$Hrubb3rY')
rescue Grooveshark::InvalidAuthentication
	puts "Ooops! Wrong username or password"
end

def play_playlist(id)
	playlist = Grooveshark::Playlist.new(@client,{'playlist_id' => id })#user.get_playlist(84280827)
	playlist.load_songs
	songs = playlist.songs
	
	song = songs.first
	url = @client.get_song_url(song)
puts url

	spawn('util/player','--play',url)
end

play_playlist(87205590)
