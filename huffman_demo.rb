require 'sinatra'
load 'huffman.rb'

enable :sessions

get '/' do
  erb :index
end

get '/tree/:filename' do
  setup_file(params[:filename])
  erb :tree
end


get '/encode/:filename' do
  if setup_file(params[:filename])
    @encoded_bits = @huffman.encode_bytes(@original_bytes)
    @current_info[:bit_length] = @encoded_bits.join.length
  end
  erb :encode
end

get '/reset' do
  session.clear
  redirect '/'
end

get '/debug' do
  erb :debug
end

not_found do
  @error = "URL '#{request.path_info}' not found"
  erb :index
end

helpers do

  def setup_file(filename)
    if @current_info = files[@current_filename = filename]
      @huffman = Huffman.new
      begin
        @original_bytes = @huffman.update_counts_from_file(@current_info[:path])
        @current_info[:symbol_count] = @huffman.node_lookup.compact.length
        @current_info[:entropy] = @huffman.entropy
      rescue
        @huffman = nil
        @error = $!.to_s
      end
    else
      @error = "Filename '#{@current_filename}' not found"
    end
    @huffman
  end

  def files
    session[:files] ||= Dir['files/*'].inject({}){|hash,filename| (stat = File.stat(filename)).directory? ? hash : (hash[File.basename(filename)] = {:path => filename,:size => stat.size}) && hash}
  end

  def commafy(s)
    s.to_s.reverse.scan(%r/.{1,3}/).join(',').reverse
  end

  def cycle(*values)
    values[(@cycle_index = (@cycle_index || 0) + 1) % values.length] # NOTE - not checking for divide-by-zero
  end

  def min_format(count)
    "%0.#{[count.to_s.length,1].max}f"
  end

  def truncate(value)
    value.to_s.split(' ').collect{| string | string.length > 128 ? string[0..127] + " ... (truncated)" : string}.join(' ')
  end

end