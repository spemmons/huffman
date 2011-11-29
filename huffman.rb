load 'byte_node.rb'
load 'heap_util.rb'
load 'console_util.rb'

class Huffman

  include ConsoleUtil
  include HeapUtil

  attr_reader :node_lookup,:total_bytes,:code_tree

  def initialize
    reset_counts
  end

  def reset_counts
    @code_tree,@total_bytes,@node_lookup = nil,0,[]
  end

  def entropy
    @node_lookup.inject(0){|sum,node| node && (p = node.count.to_f/@total_bytes) > 0 ? sum - p * Math.log2(p) : sum}
  end

  def encode_file(filename)
    bytes = update_counts_from_file(filename)
    capture_counts('encode_file',bytes.length) do
      bits = ''
      bytes.each{|byte| bits += encode_byte(byte)}
      bits
    end
  end

  def encode_bytes(bytes)
    build_code_tree
    capture_counts('encode_bytes',bytes.length) do
      bits = []
      bytes.each{|byte| bits << encode_byte(byte)}
      bits
    end
  end

  def decode_bits(bits)
    bytes = []
    current_node = build_code_tree
    bits = Array(bits).join
    capture_counts('decode_bits',bits.length) do
      bits.length.times do|index|
        count_operation('decode_bits')
        case bits[index]
          when ?0
            current_node = current_node.left_child unless current_node.byte and current_node.code == ?0
          when ?1
            current_node = current_node.right_child
          else
            raise "invalid 'bit' #{bits[index]} at #{index}"
        end
        raise "pattern does not resolve at #{index}" unless current_node
        if current_node.byte
          bytes << current_node.byte
          current_node = @code_tree
        end
      end
      raise "pattern ended without exactly matching a leaf" unless current_node == @code_tree
    end
    bytes.pack('c*')
  end

  def update_counts_from_file(filename)
    bytes = []
    capture_counts('update_counts_from_file',File.size(filename)){File.open(filename).each_byte{|byte| bytes << note_byte(byte)}}
    build_code_tree
    bytes
  end

  def encode_byte(byte)
    count_operation('encode_byte')
    raise "byte #{byte_label(byte)} not found in counts" unless node = @node_lookup[byte]
    raise "byte #{node.label} doesn't have a code" unless node.code
    node.code
  end

  def note_byte(byte)
    count_operation('note_byte')
    @total_bytes += 1
    (@node_lookup[byte] ||= ByteNode.new(byte)).count += 1
    byte
  end

  def build_code_tree
    if (priority_queue = build_priority_queue).length == 1
      @code_tree = priority_queue.first.assign_code(?0)
    else
      capture_counts('build_code_tree',priority_queue.length) do
        while priority_queue.length > 1
          new_node = ByteNode.new
          new_node.right_child = remove_heap_min(priority_queue)
          new_node.left_child = remove_heap_min(priority_queue)
          new_node.count = new_node.left_child.count + new_node.right_child.count
          add_to_heap(priority_queue,new_node)
        end
      end
      @code_tree = (priority_queue.first || ByteNode.new).assign_code('')
    end
  end

  def build_priority_queue
    capture_counts('build_priority_queue',@node_lookup.compact.length){build_heap(@node_lookup.compact.each{|node|node.reset})}
  end

  def dump
    dump_nodes(@node_lookup,@total_bytes)
  end

end