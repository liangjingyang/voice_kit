# encoding: utf-8

module VoiceKit
  module App
    @@apps = {}

    def self.register(name, klass)
      @@apps[name] = klass
    end

    def self.find(app_name)
      app_module = @@apps[app_name]
      app_module = VoiceKit::App::System unless app_module
      return app_module
    end
   
  end
end
