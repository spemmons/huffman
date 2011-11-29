module CountUtil

  attr_accessor :counts,:output

  def capture_counts(summary_label,n,&block)
    @output = true if @output.nil?
    @counts = {}
    result = block.call
    if @output
      puts "#{summary_label}: n = #{n}, T(n) = #{max_count}"
      @counts.keys.sort.each{|key| puts "- #{key}: #{@counts[key]}" unless key == summary_label}
    end
    result
  end

  def max_count
    @counts.inject(0){|previous,pair| [previous,pair.last].max}
  end

  def count_operation(label)
    @counts[label] = (@counts[label] || 0) + 1
  end

end