# Link info plugin

require 'nokogiri'
require 'open-uri'


class Cinch::Linkinfo
  include Cinch::Plugin

  match %r{(https?://.*?)(?:\s|$|,|\.\s|\.$)}, method: :grab, use_prefix: false

  def grab(message, url)
    debug "link: #{url}"
    load = Nokogiri::HTML(open(url))
    title = load.css("title")[0].text
    message.reply("#{title} - #{url}")
  end
end
