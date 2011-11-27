load 'console_util.rb'

class ByteNode
  include ConsoleUtil

  attr_accessor :byte,:count,:code,:left_child,:right_child

  def initialize(byte = nil)
    @byte,@count = byte,0
  end

  def reset
    @left_child,@right_child = nil,nil
  end

  def label
    byte_label(@byte)
  end

  def assign_code(code)
    @code = code
    @left_child.assign_code(code + '0') if @left_child
    @right_child.assign_code(code + '1') if @right_child
    self
  end

  def to_s
    byte ? format("'%c':%d",byte,count) : "#{count}"
  end

end