# encoding: utf-8
require 'yaml'
require 'chinese_number'
require 'webrick'
require 'voice_kit/mode/base'

class VoiceKit::Server < WEBrick::HTTPServlet::AbstractServlet

  STATES = [:normal, :insert]
  attr_accessor :asr, :times

  @@context = {
    config: YAML.load_file("config/voice_kit.yml"),
    modes: [],
    apps: [],
    query: [],
    buffers: {
      history: [],
      insert: [],
      command: [],
    }
  }

  def context
    @@context
  end

  def config
    context[:config]
  end

  def times
    @times || 1
  end

  def app
    context[:apps].last
  end

  def app=(app)
    context[:apps].push(app)
  end

  def mode
    context[:modes].last || :normal
  end

  def mode=(mode)
    context[:modes].push(mode)
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

  def do_GET(request, response)
    puts request
    response.status = 200
  end

  def puts_context
    puts context
    puts context.reject { |k, v| k == :config }
  end

  def do_POST(request, response)
    puts_context
    get_app
    decode(request)
    parse_command

    puts_context

    while !context[:query].empty?
      script = context[:query].shift
      puts script
      execute(script)
    end
      
    response.status = 200
  end

  def decode(request)
    @asr = request.body.force_encoding('UTF-8')
    context[:buffers][:history].push(@asr)
    puts "@asr: #{@asr}"
    context[:buffers][:history].shift if context[:buffers][:history].size > 6
    puts "context[:buffers][:history]: #{context[:buffers][:history].join(' / ')}"
  end

  def parse_command
    mode = VoiceKit::Mode::Base.create(self)
    command, times = match_times_and_command
    @times = times
    block = mode.generate_block(command)
    block.call
  end

  def get_app
    script = "osascript #{File.join(Dir.pwd, "osascripts", "get_app.applescript").gsub(/ /, '\ ')}"
    self.app = execute_with_return(script).strip
  end

  def match_times_and_command
    times = 1
    command = ChineseNumber.trans @asr
    if matches = /([0-9]+?)[次遍](.+)/.match(command)
      times = matches[1].to_i
      command = match_command(matches[2])
      return command, times
    elsif matches = /(.+?)([0-9]+?)[次遍]/.match(command)
      times = matches[2].to_i
      command = match_command(matches[1])
      return command, times
    end
    return match_command(@asr), 1
  end

  def match_command(asr)
    config["commands"].each do |conf|
      regex = Regexp.new conf['regex']
      if asr =~ regex
        return conf['command']
      end
    end
    'not_found'
  end

  def execute_with_return(script)
    `#{script}`
  end

  def execute(script)
    # execute in sub shell
    system(script)
  end
end