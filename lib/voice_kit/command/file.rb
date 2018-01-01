# encoding: utf-8
module VoiceKit
  module Command
    module File
      def command_save
        Proc.new do
          key_tap(engine.context[:key_codes]['s'], self.times, 'command')
        end
      end

      def command_close
        Proc.new do
          key_tap(engine.context[:key_codes]['w'], self.times, 'command')
        end
      end

      def command_quit
        Proc.new do
          key_tap(engine.context[:key_codes]['q'], self.times, 'command')
        end
      end

      def command_open
        Proc.new do
          key_tap(engine.context[:key_codes]['o'], self.times, 'command')
        end
      end

      def command_new
        Proc.new do
          key_tap(engine.context[:key_codes]['n'], self.times, 'command')
        end
      end

      def command_new_tab
        Proc.new do
          key_tap(engine.context[:key_codes]['t'], self.times, 'command')
        end
      end
    end
  end
end