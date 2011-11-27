module HeapUtil

  def build_heap(heap,index = 0)
    left_child_index,right_child_index = heap_child_indices(index)
    if left_child_index < heap.length
      build_heap(heap,left_child_index)
      build_heap(heap,right_child_index)
      heap_bubble_down(heap,index,[left_child_index,right_child_index])
    end
    heap
  end

  def add_to_heap(heap,new_node)
    child_index = heap.length
    heap.push new_node
    while (parent_index = (child_index - 1) / 2) >= 0 and heap[parent_index].count > heap[child_index].count
      heap[parent_index],heap[child_index] = heap[child_index],heap[parent_index]
      child_index = parent_index
    end
    heap
  end

  def remove_heap_min(heap)
    min = heap[0]
    if (bottom = heap.pop) and not heap.empty?
      heap[0] = bottom
      heap_bubble_down(heap)
    end
    min
  end

  # internal DRY methods

  def heap_child_indices(index)
    child_index = index * 2 + 1
    [child_index,child_index + 1]
  end

  def heap_bubble_down(heap,index = 0,child_indices = heap_child_indices(index))
    left_child_index,right_child_index = child_indices
    heap_bubble_down_parent_child(heap,index,left_child_index)
    heap_bubble_down_parent_child(heap,index,right_child_index)
  end

  def heap_bubble_down_parent_child(heap,parent_index,child_index)
    return if child_index >= heap.length or heap[parent_index].count < heap[child_index].count

    heap[parent_index],heap[child_index] = heap[child_index],heap[parent_index]
    heap_bubble_down(heap,child_index,heap_child_indices(child_index))
  end

end