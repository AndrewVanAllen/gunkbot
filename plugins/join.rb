class Cinch::Ircjoin
  include Cinch::Plugin

  ADMINS = ["the.shit.clocks.tickin"].freeze

  match /join (.*)/, method: :join
  match /part/, method: :part
  match /admin/, method: :admintest

  def join(message, channel)
   admins = ADMINS
   unless admins.any?{|admin| message.user.host == admin}
     message.reply("no no no")
    else
     bot.join(channel)
   end
  end

  def part(message)
   admins = ADMINS
   unless admins.any?{|admin| message.user.host == admin}
     message.reply("no no no")
    else
     bot.part(message.channel)
   end
  end

  def admintest(message)
    unless message.user.host == "the.shit.clocks.tickin"
      message.reply("no no no")
     else
      message.reply("yes yes yes")
    end
  end
end
