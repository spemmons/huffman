load 'count_util.rb'

module HeapUtil
  include CountUtil

  def build_heap(heap,index = 0)
    count_operation('build_heap')
    left_child_index,right_child_index = heap_child_indices(index)
    if left_child_index < heap.length
      build_heap(heap,left_child_index)
      build_heap(heap,right_child_index)
      heap_bubble_down(heap,index,[left_child_index,right_child_index])
    end
    heap
  end

  def add_to_heap(heap,new_node)
    count_operation('add_to_heap')
    child_index = heap.length
    heap.push new_node
    while (parent_index = (child_index - 1) / 2) >= 0 and heap[parent_index].count > heap[child_index].count
      heap[parent_index],heap[child_index] = heap[child_index],heap[parent_index]
      child_index = parent_index
      count_operation('heap_bubble_up')
    end
    heap
  end

  def remove_heap_min(heap)
    count_operation('remove_heap_min')
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

  def heap_bubble_down(heap,parent_index = 0,child_indices = heap_child_indices(parent_index))
    count_operation('heap_bubble_down')
    left_child_index,right_child_index = child_indices
    smallest_index = parent_index
    smallest_index = left_child_index if left_child_index < heap.length and heap[smallest_index].count > heap[left_child_index].count
    smallest_index = right_child_index if right_child_index < heap.length and heap[smallest_index].count > heap[right_child_index].count
    unless smallest_index == parent_index
      heap[parent_index],heap[smallest_index] = heap[smallest_index],heap[parent_index]
      heap_bubble_down(heap,smallest_index)
    end
  end

end