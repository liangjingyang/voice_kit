# encoding: utf-8

module VoiceKit
  module Mode
    module Insert
      VoiceKit::Mode.register(:insert, VoiceKit::Mode::Insert)

      def command_paste_asr
        Proc.new do
          unless insert_convert
            script = "osascript #{script_path("paste_asr.applescript")} '#{engine.asr}'"
            engine.context[:query].push(script)
          end
        end
      end

      def command_cancel
        engine.mode = :normal
        super
      end

      def command_not_found
        command_default
      end

      def command_default
        command_paste_asr
      end

      def insert_convert
        engine.context[:insert_conversions].each do |conf|
          regex = Regexp.new conf['regex']
          if engine.asr =~ regex
            key_codes = conf['key_code']
            modifiers = conf['modifier']
            if conf['size'] == 2
              pair_key_tap(key_codes, self.times, modifiers)
            else
              key_tap(key_codes, self.times, modifiers)
            end
            return true
          end
        end
        return false
      end

    end
  end
end

