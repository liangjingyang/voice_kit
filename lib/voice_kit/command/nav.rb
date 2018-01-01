# encoding: utf-8
module VoiceKit
  module Command
    module Nav
      def command_swich_window
        Proc.new do
          key_tap(engine.context[:key_codes]['`'], self.times, 'command', 0.5)
        end
      end
      def command_left
        Proc.new do
          key_tap(engine.context[:key_codes]['left'], self.times)
        end
      end
      def command_right
        Proc.new do
          key_tap(engine.context[:key_codes]['right'], self.times)
        end
      end
      def command_up
        Proc.new do
          key_tap(engine.context[:key_codes]['up'], self.times)
        end
      end
      def command_down
        Proc.new do
          key_tap(engine.context[:key_codes]['down'], self.times)
        end
      end
      def command_page_up
        Proc.new do
          key_tap(engine.context[:key_codes]['page_up'], self.times)
        end
      end
      def command_page_down
        Proc.new do
          key_tap(engine.context[:key_codes]['page_down'], self.times)
        end
      end
      def command_home
        Proc.new do
          key_tap(engine.context[:key_codes]['home'], self.times)
        end
      end
      def command_end
        Proc.new do
          key_tap(engine.context[:key_codes]['end'], self.times)
        end
      end
      def command_page_home
        Proc.new do
          key_tap(engine.context[:key_codes]['up'], self.times, 'command')
        end
      end
      def command_page_end
        Proc.new do
          key_tap(engine.context[:key_codes]['down'], self.times, 'command')
        end
      end
    end
  end
end