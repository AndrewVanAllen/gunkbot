# Quotes plugin
require 'sqlite3'

class Cinch::Quotes
  include Cinch::Plugin

  # match commands
  match /q add (\S*) (.*)/, method: :add_quote
  match /q (\S*)( \d*)?$/, method: :view_quote

  # set quotes db file uri, and main db call
  @@quote_db_file = "./data/quotes.sqlite"
  @@quote_db = SQLite3::Database.new(@@quote_db_file)

  # add block
  def add_quote(message, nick, quote)

    # insert query
    insert_quote = "INSERT INTO quotes(nick, quote) VALUES(?, ?)"
    # insert quote
    @@quote_db.execute(insert_quote, nick.to_s, quote.to_s)
    message.reply("it has been done.")

    #debug "#{nick}, #{quote}"
    #debug "#{insert_quote}"
    #debug "#{@@quote_db.execute(get_quote)}"
  end

  # view block
  def view_quote(message, nick, quote_num)

    # retrieve queries
    get_quote = "SELECT quote FROM quotes WHERE nick='#{nick}'"
    get_quote_r = "SELECT * FROM quotes WHERE nick='#{nick}'"

    # if quote_num isnt set
    if !quote_num
      if @@quote_db.execute(get_quote_r).empty?
        message.reply("nothing exists.")
       else
        message.reply("#{nick}: #{@@quote_db.execute(get_quote_r).sample[1]}")
      end
     # if quote doesnt exist
     elsif !@@quote_db.execute(get_quote)[quote_num.to_i]
      message.reply("that quote only exists in your mind")
     else
      quote_num = quote_num.delete "\s"
      message.reply("#{nick} [#{quote_num}]: #{@@quote_db.execute(get_quote)[quote_num.to_i][0]}")
    end

    #debug "#{nick}, #{quote_num}"
    #debug "#{@@quote_db.execute(get_quote_r).sample[1]}"
  end
end
