# encoding: utf-8
require 'forwardable'

module VoiceKit
  module Mode
    class Base
      @@modes = {}
      attr_accessor :server

      extend Forwardable

      def self.register(name, klass)
        @@modes[name] = klass
      end

      def self.create(server)
        puts @@modes
        mode_instance = @@modes[server.mode].new(server)
        mode_instance = VoiceKit::Mode::Normal.new(server) unless mode_instance
        app_module = VoiceKit::App.find(server.app)
        mode_instance.extend(app_module)
        puts mode_instance.class
        puts app_module
        return mode_instance
      end

      def initialize(server)
        @server = server
      end

      def generate_block(command)
        command = ['command', command.to_s].join('_')
        if self.respond_to?(command)
          self.send(command)
        else
          self.command_not_found
        end
      end

      def command_mode_to_insert
        if server.mode == :insert
          command_default
        else 
          Proc.new { server.mode = :insert }
        end
      end

      def command_mode_to_normal
        if server.mode == :normal
          command_default
        else 
          Proc.new { server.mode = :normal }
        end
      end

      def command_cancel
        Proc.new do
          key_tap(server.config['key_codes']['esc'], server.times)
        end
      end

      def command_swich_app
        Proc.new do
          key_tap(server.config['key_codes']['caps_lock'], server.times)
        end
      end
      
      def command_swich_app
        Proc.new do
          key_tap(server.config['key_codes']['tab'], server.times, 'command', 0.5)
        end
      end

      def command_swich_window
        Proc.new do
          key_tap(server.config['key_codes']['`'], server.times, 'command', 0.5)
        end
      end

      def command_undo
        Proc.new do
          key_tap(server.config['key_codes']['z'], server.times, 'command')
        end
      end

      def command_redo
        Proc.new do
          key_tap(server.config['key_codes']['z'], server.times, 'command,shift')
        end
      end

      def command_delete
        Proc.new do
          key_tap(server.config['key_codes']['delete'], server.times)
        end
      end

      def command_copy
        Proc.new do
          key_tap(server.config['key_codes']['c'], server.times, 'command')
        end
      end

      def command_paste
        Proc.new do
          key_tap(server.config['key_codes']['v'], server.times, 'command')
        end
      end

      def command_cut
        Proc.new do
          key_tap(server.config['key_codes']['x'], server.times, 'command')
        end
      end

      def command_open
        Proc.new do
          key_tap(server.config['key_codes']['o'], server.times, 'command')
        end
      end

      def command_new
        Proc.new do
          key_tap(server.config['key_codes']['n'], server.times, 'command')
        end
      end

      def command_new_tab
        Proc.new do
          key_tap(server.config['key_codes']['t'], server.times, 'command')
        end
      end

      def command_find
        Proc.new do
          key_tap(server.config['key_codes']['f'], server.times, 'command')
        end
      end

      def command_save
        Proc.new do
          key_tap(server.config['key_codes']['s'], server.times, 'command')
        end
      end

      def command_close
        Proc.new do
          key_tap(server.config['key_codes']['w'], server.times, 'command')
        end
      end

      def command_quit
        Proc.new do
          key_tap(server.config['key_codes']['q'], server.times, 'command')
        end
      end

      def command_select_all
        Proc.new do
          key_tap(server.config['key_codes']['a'], server.times, 'command')
        end
      end

      def command_not_found
        puts "command not found. try to press key: #{server.asr}"
        command_key_tap
      end

      def command_default
        puts "default command not found. try to press key: #{server.asr}"
        command_key_tap
      end

      def command_key_tap
        Proc.new do
          server.config['key_codes'].each do |key, code|
            if server.asr == key
              key_tap(code)
              break;
            end
          end
        end
      end

      def key_tap(key_codes, times=1, modifiers=nil, delay=nil)
        key_codes = safe_str(key_codes)
        modifiers = safe_str(modifiers)
        script = "osascript #{script_path("key_tap.applescript")} #{key_codes} #{times}"
        script = "#{script} #{modifiers} #{delay}".strip
        server.context[:query].push(script)
      end

      def pair_key_tap(key_codes, times=1, modifiers=nil)
        key_tap(key_codes, times=1, modifiers=nil)
        script = "osascript #{script_path("key_tap.applescript")} 123 1" # left 1
        server.context[:query].push(script)
      end

      def safe_str(str)
        str.to_s.split(/,\s|,/).join(',')
      end

      def script_path(script_name, app_name='')
        File.join(root_path, "osascripts", app_name, script_name).gsub(/ /, '\ ')
      end

      def root_path
        File.join(Dir.pwd).gsub(/ /, '\ ')
      end

    end
  end
end