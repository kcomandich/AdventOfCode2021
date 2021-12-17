require 'pry-byebug'

HEX_TABLE = {
  "0" => "0000",
  "1" => "0001",
  "2" => "0010",
  "3" => "0011",
  "4" => "0100",
  "5" => "0101",
  "6" => "0110",
  "7" => "0111",
  "8" => "1000",
  "9" => "1001",
  "A" => "1010",
  "B" => "1011",
  "C" => "1100",
  "D" => "1101",
  "E" => "1110",
  "F" => "1111"
}.freeze

class PacketDecoder
  attr_accessor :versions

  def initialize
    @versions = []
    packet = IO.read("input.txt")
    puts "Packet: #{packet}"
    unless packet.match(/[2-9A-F]/).nil?
      packet = hex_to_binary(packet)
      puts "Decoded Packet in binary: #{packet}"
    end
    decode(packet)
  end

  def hex_to_binary(packet)
    packet.chars.map(&HEX_TABLE).join
  end

  def decode(packet)
    @versions << version(packet).to_i
    case type_id(packet)
    when 4 # literal value
      result = ''
      while( subpacket = packet.slice!(0,5) )
        result += subpacket.slice(1,4)
        break if subpacket[0] == '0'
      end
      puts "*** Literal value: #{to_decimal(result)} ***"
    else # operator
      if length_type_id(packet) == '0'
        sub_length = sub_length(packet)
        start_length = packet.length
        return if sub_length == 0
        while( packet.length >= start_length - sub_length )
#          puts "Packet length: #{packet.length}; Start length: #{start_length}; Sub length: #{sub_length}"
#          puts "Remaining packet: #{packet}"
          decode(packet)
        end
      else
        num_subpackets(packet).times{ decode(packet) }
      end
    end
  end

  def num_subpackets(packet)
    num = to_decimal(packet.slice!(0,11))
    puts "Number of subpackets: #{num}"
    num
  end

  def length_type_id(packet)
    id = packet.slice!(0)
    puts "Length Type ID: #{id}"
    id
  end

  def sub_length(packet)
    l = to_decimal(packet.slice!(0,15))
    puts "Total length: #{l}"
    l
  end

  def version(packet)
    v = to_decimal(packet.slice!(0,3).rjust(4, '0'))
    puts "== Version: #{v} =="
    puts "Remaining packet: #{packet}"
    v
  end

  def type_id(packet)
    t = to_decimal(packet.slice!(0,3).rjust(4, '0'))
    puts "Type ID: #{t}"
    t
  end

  def to_decimal(binary)
    binary.reverse.chars.map.with_index do |digit, index|
      digit.to_i * 2**index
    end.sum
  end
end

if $PROGRAM_NAME == __FILE__
  pd = PacketDecoder.new
  puts "All versions: "
  pp pd.versions
  puts "Sum of all versions: #{pd.versions.sum}"
#  puts "Number: #{pd.number} = #{pd.to_decimal(pd.number)}"
end
