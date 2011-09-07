# Simple RingBuffer implementation
class CircleBuffer < Array

  alias_method :array_push, :push
  alias_method :array_element, :[]
  alias_method :array_length, :length
    
  def initialize( size )
    @ring_size = size
    super( size )
  end

  def push( element )
    if array_length == @ring_size
      shift # loose element
    end
    array_push element
  end

  def <<( element )
    push element
  end
  
  # Access elements in the RingBuffer
  def []( offset = 0 )
    return self.array_element( - 1 + offset )
  end

  def length
    self.compact.size
  end
  
  def sum
    self.compact.instance_eval { reduce(:+) }
  end
  
  def average
    sum / length.to_f
  end
end
