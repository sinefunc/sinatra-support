# Taken from ohm

unless "".respond_to?(:lines)
  # @private 1.8.6 compatibility only
  class String
    # @private
    # This version of String#lines is almost fully compatible with that
    # of Ruby 1.9. If a zero-length record separator is supplied in Ruby
    # 1.9, the string is split into paragraphs delimited by multiple
    # successive newlines. This replacement ignores that feature in
    # favor of code simplicity.
    def lines(separator = $/)
      result = split(separator).map { |part| "#{part}#{separator}" }
      result.each { |r| yield r } if block_given?
      result
    end
  end
end

unless respond_to?(:tap)
  # @private 1.8.6 compatibility only
  class Object
    # @private no need to explain. Standard ruby 1.9 stuff.
    # @see http://ruby-doc.org/ruby-1.9/classes/Object.html#M000239
    def tap
      yield(self)
      self
    end
  end
end
