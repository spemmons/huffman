module ConsoleUtil
  
  def byte_label(byte)
    return '---' unless byte
    
    case c = [byte].pack('c')
      when /[\d\w \~\`\!\@\#\$\%\^\&\*\(\)\-\_\+\=\\\|\;\:\'\"\,\<\.\>\/\?\[\{\]\}]/
        "'#{c}'"
      when "\n"
        "'\\n'"
      when "\r"
        "'\\r'"
      when "\t"
        "'\\t'"
      else
        format('?%02X',byte)
    end
  end

  def dump_heap(heap,index = 0,level = 0,levels = [])
    if index < heap.length
      (levels[level] ||= []) << [heap[index].byte,heap[index].count]
      left_child_index,right_child_index = heap_child_indices(index)
      dump_heap(heap,left_child_index,level + 1,levels)
      dump_heap(heap,right_child_index,level + 1,levels)
    end
    levels
  end

  def dump_tree(node)
    return [[node]] if node.byte

    left_paths = dump_tree_children(node.left_child,'-^ ',false)
    right_paths = dump_tree_children(node.right_child,'-v ',true)

    all_paths = left_paths + [[nil,' +-',node]] + right_paths
    max_length = all_paths.collect{|p| p.length}.max
    all_paths.collect do |path|
      leaf = path[0,1]
      insertion = leaf[0] ? ['---'] : [nil]
      path = path[0,1] + insertion + path[1..-1] while path.length < max_length
      path
    end
  end

  def dump_tree_children(node,corner_string,before)
    insertion,pending = before ? [' | ',nil] : [nil,' | ']
    (node ? dump_tree(node) : [[nil]]).each do |p|
      if p.last
        p << corner_string
        insertion = pending
      else
        p << insertion
      end
      p << nil
    end
  end

  def dump_nodes(nodes,total_bytes)
    symbol_count = 0
    nodes.each{|node| next unless node; symbol_count += 1; puts format('%s => %d (%0.06f) %s (%d)',node.label,node.count,node.count.to_f/total_bytes,node.code || '?',node.code.to_s.length)}
    puts "TOTAL:#{total_bytes} SYMBOLS:#{symbol_count}"
  end

end