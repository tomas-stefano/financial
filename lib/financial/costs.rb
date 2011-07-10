module Financial
  class Costs < Array
    def parcels(number)
      parcels = Parcels.new(number)
      self.push(parcels)
      parcels
    end

    def replace_parcels_with_costs!
      costs = self.select { |cost| cost.is_a?(Parcels) }.collect do |parcels|
        self.delete(parcels)
        parcels.to_cost
      end
      costs.flatten.each { |cost| self.push(cost) }
    end

    def method_missing(meth, *args, &blk)
      unless args.empty?
        cost = Cost.new(meth, args)
        self.push(cost)
        cost
      else
        raise CostWithoutValue, "Cost: #{meth} don't have a value. Pass a value!"
      end
    end
  end

  class CostWithoutValue < StandardError
  end
end