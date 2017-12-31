# encoding: utf-8
require 'voice_kit/engine'

class VoiceKit::Server < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    puts request
    response.status = 200
  end

  def do_POST(request, response)
    asr = decode(request)
    engine = VoiceKit::Engine.new(asr)
    engine.go
    response.status = 200
  end

  def decode(request)
    request.body.force_encoding('UTF-8')
  end
end