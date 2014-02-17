class String
  def to_bool
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/^(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
 
class Fixnum
  def to_bool
    return true if self == 1
    return false if self == 0
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end
 
class TrueClass
  def to_i; 1; end
end
 
class FalseClass
  def to_i; 0; end
end
class Hash
  def sort_by_key(recursive = false, &block)
    self.keys.sort(&block).reduce({}) do |seed, key|
      seed[key] = self[key]
      if recursive && seed[key].is_a?(Hash)
        seed[key] = seed[key].sort_by_key(true, &block)
      end
      seed
    end
  end
end