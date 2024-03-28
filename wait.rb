require 'websocket-eventmachine-client'

# WebSocket server URL
websocket_url = 'ws://your-websocket-server-url'

# Define WebSocket event handler
event_handler = Class.new do
  def initialize
    @allowed_origin = 'http://psyph3r.com'
  end

  def on_message(msg, _type)
    puts "Received message: #{msg}"
  end

  def on_open
    puts 'WebSocket connection established.'
  end

  def on_close(code, reason)
    puts "WebSocket connection closed with code: #{code} and reason: #{reason}"
  end

  def on_error(error)
    puts "Error encountered: #{error}"
  end

  def on_handshake(req)
    origin = req.headers['Origin']
    if origin != @allowed_origin
      puts "Rejected connection from #{origin}."
      raise "Connection from #{origin} is not allowed."
    end
  end
end.new

# Establish WebSocket connection
WebSocket::EventMachine::Client.connect(uri: websocket_url, on_open: event_handler.method(:on_open), on_message: event_handler.method(:on_message), on_close: event_handler.method(:on_close), on_error: event_handler.method(:on_error), on_handshake: event_handler.method(:on_handshake))

# Keep the event loop running
EventMachine.run do
  trap('INT') do
    EventMachine.stop
  end
end
