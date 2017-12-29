# encoding: utf-8
module VoiceKit
  module App
    @@apps = {}
    def self.register(name, klass)
      @@apps[name] = klass
    end

    def self.find(app_name)
      app_class = @@apps[app_name]
      app_class = VoiceKit::App::System unless app_class
      return app_class
    end
    
    def hello
      puts @@apps
    end
  end
end
