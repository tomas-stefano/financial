module Financial
  class Revenues < Array
    def method_missing(meth, *args, &blk)
      unless args.empty?
        revenue = Revenue.new(meth, args)
        self.push(revenue)
        revenue
      else
        raise RevenueWithoutValue, "Revenue: #{meth} don't have a value. Pass a value!"
      end
    end
  end

  class RevenueWithoutValue < StandardError
  end
end