class Password < ApplicationRecord
  self.abstract_class = true
  attr_accessor :pw_string, :upcase_first, :add_num, :spec_char, :upcase_any
end
