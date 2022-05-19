class Password < ApplicationRecord
  self.abstract_class = true
  attr_accessor :pw_string
end
