# encoding: utf-8
module VoiceKit
  module App
    module Chrome
      @@app_name = 'Chrome'
      @@app_commands = YAML.load_file("config/app/#{@@app_name}.yml")
      VoiceKit::App.register(@@app_name, VoiceKit::App::Chrome)
      
      def self.extended(instance)
        instance.app_name = @@app_name
        instance.app_commands = @@app_commands
      end

      def command_active_input_and_link
        Proc.new do
          engine.mode = :normal
          key_tap(engine.context[:key_codes]['f'], self.times)
        end
      end

      def command_default
        if engine.mode == :insert
          puts "super"
          super
          # command_paste_asr
        else
          puts engine.asr
          puts engine.app
          puts app_name
          Proc.new do
            script = "osascript #{script_path("select_text.applescript", app_name)} '#{engine.asr}'"
            puts script
            engine.context[:query].push(script)
          end
        end
      end
    end
  end
end