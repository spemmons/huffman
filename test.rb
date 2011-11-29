load 'huffman.rb'

def test_file(filename)
  huffman = Huffman.new
#  huffman.output = false
  puts "FILE:#{filename}"
  original_bytes = huffman.update_counts_from_file(filename)
  puts "...BYTES:#{original_bytes.length}\n...ORIGINAL:#{original_bytes.length * 8}"
  encoded_bits = Array(huffman.encode_bytes(original_bytes)).join
  puts "...ENCODING:#{encoded_bits.length}"
  decoded_string = huffman.decode_bits(encoded_bits)
  original_string = original_bytes.pack('c*')
  puts "...DECODING:#{result = original_string == decoded_string}"
  puts "...WAS:#{original_string}\n...NOW:#{decoded_string}" unless result
end

Dir['files/*'].each{|filename| test_file(filename)}