# encoding: utf-8
module VoiceKit
  module App
    module System
      include VoiceKit::App
      VoiceKit::App.register('System', VoiceKit::App::System)
    end
  end
end