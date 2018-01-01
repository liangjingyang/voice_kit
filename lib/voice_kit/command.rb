# encoding: utf-8
require 'voice_kit/command/file'
require 'voice_kit/command/edit'
require 'voice_kit/command/nav'
module VoiceKit
  module Command
    include VoiceKit::Command::File
    include VoiceKit::Command::Edit
    include VoiceKit::Command::Nav

    def command_active_debug
      Proc.new { engine.debug = true }
    end

    def command_deactive_debug
      Proc.new { engine.debug = false }
    end
      
    def command_mode_to_insert
      if engine.mode == :insert
        command_default
      else 
        Proc.new { engine.mode = :insert }
      end
    end

    def command_mode_to_normal
      if engine.mode == :normal
        command_default
      else 
        Proc.new { engine.mode = :normal }
      end
    end

    def command_cancel
      Proc.new do
        key_tap(engine.context[:key_codes]['esc'], self.times)
      end
    end

    def command_caps_lock
      Proc.new do
        key_tap(engine.context[:key_codes]['caps_lock'], self.times)
      end
    end

    def command_swich_app
      Proc.new do
        key_tap(engine.context[:key_codes]['tab'], self.times, 'command', 0.5)
      end
    end

    def command_active_app
      Proc.new do
        matches = regex.match(engine.asr)
        if last = matches[matches.size - 1]
          engine.context[:app_name_conversions].each do |conf|
            regex = Regexp.new conf['regex']
            if last =~ regex
              script = "osascript #{script_path("active_app.applescript")} #{conf['app_name'].shellescape}"
              engine.context[:query].push(script)
              break
            end
          end
        end
      end
    end

    def command_enter
      Proc.new do
        key_tap(engine.context[:key_codes]['enter'], self.times)
      end
    end

    def command_space
      Proc.new do
        key_tap(engine.context[:key_codes]['space'], self.times)
      end
    end

    def command_multiple_key_tap
      Proc.new do
        modifier = /大写/ =~ engine.asr ? 'shift' : ''
        engine.asr.downcase.downcase.each_char do |char|
          engine.context[:key_codes].each do |key, code|
            if char == key
              key_tap(code, 1, modifier)
              break;
            end
          end
        end
      end
    end

    def command_not_found
      puts "command not found. try to press key: #{engine.asr}"
      command_default
    end

    def command_default
      puts "default command not found. try to press key: #{engine.asr}"
      command_key_tap
    end

    def command_key_tap
      Proc.new do
        engine.context[:key_codes].each do |key, code|
          if engine.asr.downcase == key
            key_tap(code)
            break;
          end
        end
      end
    end

   
  end
end