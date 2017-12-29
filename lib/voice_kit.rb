require "voice_kit/version"
require "voice_kit/server"
require "voice_kit/app"
require "voice_kit/app/system"
require 'voice_kit/mode/base'
require 'voice_kit/mode/normal'
require 'voice_kit/mode/insert'
require 'webrick'

module VoiceKit
  def self.start
    server = WEBrick::HTTPServer.new(:Port => 8080)
    server.mount "/", VoiceKit::Server
    trap "INT" do server.shutdown end
    server.start
  end
end

VoiceKit.start