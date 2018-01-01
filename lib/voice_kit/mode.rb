# encoding: utf-8

module VoiceKit
  module Mode
    @@modes = {}
    
    def self.register(name, klass)
      @@modes[name] = klass
    end

    def self.find(name)
      mode_class = @@modes[name]
      mode_class = VoiceKit::Mode::Normal unless mode_class
      return mode_class
    end

  end
end