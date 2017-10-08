require "socket"
class Connection

  def initialize(ip, port)
    if(ip == "localhost")
      @ip = Socket.ip_address_list[3].ip_address
    else
      @ip = ip
    end

    @port = port

    # connect to server
    @connection = TCPSocket.new(@ip, @port)

    # set the encoding of the connection to UTF-8
    @connection.set_encoding(Encoding::UTF_8)
  end

  def sending(msg)


    puts @connection.addr(true).to_s
    # send message
    puts msg
    @connection.puts(msg)
    msg = @connection.gets.chop.force_encoding(Encoding::UTF_8)
    return msg
  end
end

c = Connection.new("localhost", 4713)
c.sending("signIn;tim;1234")