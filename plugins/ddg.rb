# Duckduckgo

require "nokogiri"
require "open-uri"

class Cinch::DDGSearch
  include Cinch::Plugin

  match /ddg (.*)/, method: :search

  def search(message, term)

    search_url = "https://duckduckgo.com/html/?q=#{term}"
    load = Nokogiri::HTML(open(search_url))

    title_attr = load.css("a.result__a")
    title = title_attr[0].text
    url_attr = load.css("a.result__url")
    message_url = url_attr[0].text.delete "\s\n"
    desc_attr = load.css("a.result__snippet")
    desc = desc_attr[0].text
    result = "#{title}: http://#{message_url} - #{desc}"
    message.reply(result)
  end
end
