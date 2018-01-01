# encoding: utf-8
require 'chinese_number'
require 'os'

module VoiceKit
  class Engine
    include VoiceKit::Command

    STATES = [:normal, :insert]
    attr_accessor :asr, :regex, :times

    # will init on app module extended
    attr_accessor :app_name, :app_commands
    
  
    @@context = {
      commands: YAML.load_file("config/commands.yml"),
      key_codes: YAML.load_file("config/key_codes.yml"),
      insert_conversions: YAML.load_file("config/insert_conversions.yml"),
      app_name_conversions: YAML.load_file("config/app_name_conversions.yml"),
      modes: [],
      apps: [],
      query: [],
      history: [],
      debug: false,
    }

    def initialize(asr)
      @asr = asr
      context[:history].push(@asr)
      context[:history].shift if context[:history].size > 10

      get_app
      extend_mode
      extend_app

      log_debug "@asr: #{@asr}"
      # log_debug app_name
      # log_debug app_commands
      execute("osascript #{script_path("display_notification.applescript")} '#{@asr}'") if debug
    end

    def go
      begin
        proc = generate_block
        # this maybe add some script to query
        proc.call

        while !context[:query].empty?
          script = context[:query].shift
          log_debug script
          execute(script)
        end

        puts_context
        
      rescue Exception => e
        puts_context
        puts e.message
      end
    end
    
    def generate_block
      command, @regex, @times = match_semantic_and_command
      puts "command: #{command} | @regex: #{@regex} | @times: #{@times}"
      command = ['command', command.to_s].join('_')
      if self.respond_to?(command)
        self.send(command)
      else
        self.command_not_found
      end
    end

    def match_semantic_and_command
      times = 1
      command = ChineseNumber.trans @asr
      if matches = /([0-9]+?)[次遍行页个下](.+)/.match(command)
        times = matches[1].to_i
        return *match_command(matches[1]), regex, times
      elsif matches = /(.+?)([0-9]+?)[次遍行页个下]/.match(command)
        times = matches[2].to_i
        return *match_command(matches[1]), times
      end
      return *match_command(@asr), 1
    end

    def match_command(asr)
      app_commands.each do |group_key, group_values|
        group_values.each do |conf|
          regex = Regexp.new conf['regex']
          if asr =~ regex
            return conf['command'], regex
          end
        end if group_values
      end if app_commands
      context[:commands].each do |group_key, group_values|
        group_values.each do |conf|
          regex = Regexp.new conf['regex']
          if asr =~ regex
            return conf['command'], regex
          end
        end
      end
      'not_found'
    end

    def extend_mode
      mode_module = VoiceKit::Mode.find(engine.mode)
      self.extend(mode_module)
      log_debug "extend #{mode_module}"
    end

    def extend_app
      app_module = VoiceKit::App.find(engine.app)
      self.extend(app_module)
      log_debug "extend #{app_module}"
    end

    def get_app
      script = "osascript #{script_path("get_app_name.applescript").shellescape}"
      self.app = execute_with_return(script).strip
    end

    def execute_with_return(script)
      `#{script}`
    end

    def execute(script)
      # execute in sub shell
      system(script)
    end

    def puts_context
      # log_debug context
      log_debug context.reject { |k, v| [:commands, :key_codes, :insert_conversions, :app_name_conversions].include? k }
    end

    def engine
      self
    end
  
    def context
      @@context
    end
  
    def times
      @times || 1
    end

    def debug
      context[:debug]
    end
  
    def debug=(bool)
      context[:debug] = bool
    end
  
    def app
      context[:apps].last
    end
  
    def app=(app)
      context[:apps].push(app)
      context[:apps].shift if context[:apps].size > 10
    end
  
    def mode
      context[:modes].last || :normal
    end
  
    def mode=(mode)
      context[:modes].push(mode)
      context[:modes].shift if context[:modes].size > 10
    end
  
    def prev_mode(index)
      size = context[:modes]
      if index > 0 && index <= size
        context[:modes][size - index]
      elsif index < 0 && -index <= size
        context[:modes][index]
      else
        :normal
      end
    end

    def key_tap(key_codes, times=1, modifiers=nil, delay=nil)
      key_codes = safe_str(key_codes)
      modifiers = safe_str(modifiers)
      script = "osascript #{script_path("key_tap.applescript")} #{key_codes} #{times}"
      script = "#{script} #{modifiers} #{delay}".strip
      engine.context[:query].push(script)
    end

    def pair_key_tap(key_codes, times=1, modifiers=nil)
      key_tap(key_codes, times=1, modifiers=nil)
      script = "osascript #{script_path("key_tap.applescript")} 123 1" # left 1
      engine.context[:query].push(script)
    end

    def safe_str(str)
      str.to_s.split(/,\s|,/).join(',')
    end

    def script_path(script_name, app_name='')
      if OS.mac?
        ::File.join(root_path, "osascripts/darwin", app_name, script_name).shellescape
      else
        raise Exception.new("Don't have script on #{OS.host_os}")
      end
    end

    def root_path
      ::File.join(Dir.pwd).shellescape
    end

    def log_debug(str)
      puts str if debug
    end
  end
end