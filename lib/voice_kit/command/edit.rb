# encoding: utf-8
module VoiceKit
  module Command
    module Edit
      def command_undo
        Proc.new do
          key_tap(engine.context[:key_codes]['z'], self.times, 'command')
        end
      end

      def command_redo
        Proc.new do
          key_tap(engine.context[:key_codes]['z'], self.times, 'command,shift')
        end
      end

      def command_delete
        Proc.new do
          key_tap(engine.context[:key_codes]['delete'], self.times)
        end
      end

      def command_copy
        Proc.new do
          key_tap(engine.context[:key_codes]['c'], self.times, 'command')
        end
      end

      def command_paste
        Proc.new do
          key_tap(engine.context[:key_codes]['v'], self.times, 'command')
        end
      end

      def command_cut
        Proc.new do
          key_tap(engine.context[:key_codes]['x'], self.times, 'command')
        end
      end

      def command_find
        Proc.new do
          key_tap(engine.context[:key_codes]['f'], self.times, 'command')
          engine.mode = :insert
        end
      end


      def command_select_all
        Proc.new do
          key_tap(engine.context[:key_codes]['a'], self.times, 'command')
        end
      end

    end
  end
end
