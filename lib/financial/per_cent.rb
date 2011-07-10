module Financial
  module PerCent
    def self.included(base)
      Numeric.class_eval do
        def per_cent
          self / 100.0
        end
        Financial.locale.add_per_cent_aliases
      end
    end
  end
end