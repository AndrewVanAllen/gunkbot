# Shitty response plugin

class Cinch::Responses
  include Cinch::Plugin

  match /^uguu/, method: :uguu, use_prefix: false

  def uguu(message)
    message.reply("uguu~")
  end
end
