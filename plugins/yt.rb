# Youtube plugin
#
# screw google and it's undocumented api
#

require "nokogiri"
require "open-uri"

class Cinch::YouTube
  include Cinch::Plugin

  match /yt (.*)/, method: :youtube_search

  def youtube_search(message, user_term)
    user_term = user_term.strip
    search_url = "https://youtube.com/results?search_query=#{user_term}"
    load = Nokogiri::HTML(open(search_url))

    link_attr = load.css("a[href^='/watch']")
    title = link_attr[1]["title"]
    url = link_attr[1]["href"]
    result = "#{title} - https://youtube.com#{url}"
    debug "#{result}"
    message.reply("#{result}")
  end
end