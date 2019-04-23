# Sound bank plugin
#
# A plugin to serve links to songs based on genres from user-added links.
#

require 'sqlite3'

class Cinch::SoundBank
  include Cinch::Plugin

  match /snd help/, method: :help_method
  match /snd add (.*) ((https?:\/\/)?(w{3}\.)?(youtube\.com|youtu.be)\/(watch\?v=)?(\S{11}))/, method: :add_song
  match /snd genres/, method: :genre_list
  match /snd get (.*)?/, method: :get_song

  def help_method(message)
    message.reply(".snd: Usage: .snd [option]")
    message.reply("      get [genre, optional]        : Gets a random song")
    message.reply("      add [genre] [youtube link]   : Adds a song to genre")
    message.reply("      genres                       : Lists genres")
    message.reply("      help                         : Show this help message")
  end

  @@soundbank_db_file = "./data/soundbank.sqlite"
  @@soundbank_db = SQLite3::Database.new(@@soundbank_db_file)

  def add_song(message, genre, link)
    insert_song = "INSERT INTO songs(genre, link) VALUES(?, ?)"
    genre = genre.downcase
    debug "#{genre}, #{link}"
    @@soundbank_db.execute(insert_song, genre.to_s, link.to_s)
    message.reply("added to #{genre}")
  end
  def get_song(message, genre)
    genre = genre.downcase
    debug "#{genre}"
    get_song_r = "SELECT * FROM songs"
    get_song_from_genre = "SELECT * FROM songs WHERE genre='#{genre.strip}'"

    if !genre
      message.reply("#{@@soundbank_db.execute(get_song_r).sample[1]}")
    elsif !@@soundbank_db.execute(get_song_from_genre)[0]
      message.reply("no sounds from there")
    else
      message.reply("#{@@soundbank_db.execute(get_song_from_genre).sample[1]}")
    end
  end
  def genre_list(message)
    get_genres = "SELECT genre FROM songs"
    genre_array = @@soundbank_db.execute(get_genres)
    genre_array = genre_array.uniq
    message.reply("#{genre_array.join(', ')}")
  end

end