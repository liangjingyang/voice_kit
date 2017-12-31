require 'shellwords'
require 'webrick'
require 'chinese_number'
require 'yaml'
require "voice_kit/app"
require "voice_kit/app/system"
require "voice_kit/app/google_chrome"
require "voice_kit/command"
require "voice_kit/mode"
require "voice_kit/mode/insert"
require "voice_kit/mode/normal"
require "voice_kit/version"
require "voice_kit/server"
require "voice_kit/engine"

module VoiceKit
  def self.start
    server = WEBrick::HTTPServer.new(:Port => 8080)
    server.mount "/", VoiceKit::Server
    trap "INT" do server.shutdown; end
    server.start
  end
end

VoiceKit.start