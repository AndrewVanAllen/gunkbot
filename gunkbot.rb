# Requires
require "cinch"
require "fileutils"
require "cinch/plugins/identify"
require_relative "plugins/responses"
require_relative "plugins/join"
require_relative "plugins/link"
require_relative "plugins/ddg"
require_relative "plugins/quotes"
require_relative "plugins/yt"
require_relative "plugins/snd_bank"

# Memo code
class Memo < Struct.new(:nick, :channel, :text, :time)
  def to_s
    "[#{time.asctime}] <#{channel}/#{nick}> #{text}"
  end
end

$memos = {}

# Bot Config
gunk = Cinch::Bot.new do
  configure do |config|
    # serv
    config.server = "irc.server.here"
    config.port = 6667

    config.ssl.use = false
    config.ssl.verify = false

    config.channels = ["#channel"]
    config.nick = "gunkbot"
    config.user = "gunk"

    # plugins
    config.plugins.prefix = /^\./
    config.plugins.plugins = [Cinch::Plugins::Identify, Cinch::Responses, Cinch::Ircjoin, Cinch::Linkinfo, Cinch::DDGSearch, Cinch::Quotes, Cinch::YouTube, Cinch::SoundBank]
    config.plugins.options[Cinch::Plugins::Identify] = {
      :type     => :nickserv,
      :password => "password",
    }
  end

  # Memo events
  on :message do |m|
    if $memos.has_key?(m.user.nick)
      m.user.send $memos.delete(m.user.nick).to_s
    end
  end

  on :message, /^!memo (.+?) (.+)/ do |m, nick, message|
    if $memos.key?(nick)
      m.reply "There's already a memo for #{nick}. You can only store one right now"
    elsif nick == m.user.nick
      m.reply "can you remember"
    elsif nick == bot.nick
      m.reply "im not real"
    else
      $memos[nick] = Memo.new(m.user.nick, m.channel, message, Time.now)
      m.reply "Added memo for #{nick}"
    end
  end

  # Close on ctrl+c
  trap "SIGINT" do
    bot.quit
  end
end

# start
gunk.start
