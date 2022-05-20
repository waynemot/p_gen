class Generator < ApplicationRecord
  self.abstract_class = true

  attr_accessor :len, :upcase_first, :spec_char, :upcase_any
  @consonants = %w[b c d f g h j k l m n p r s t v w x y z]
  @digits = { 'l' => 1, 'e' => 3, 'o' => 0, 'b' => 6, 't' => 7, 'g' => 9, 'c' => 2, 'h' => 5, 'r' => 4, 'd' => 8}
  @vowels = %w[a e i o u]
  @specials = %w[! @ # $ % ^ * & * - + ?]

  def self.gen(len = 8, upcase_first = false, spec_char = false, upcase_any = false)
    work_str = ""
    odd_len = false
    if len >= 6
      if (len % 2) != 0
        odd_len = true
      end
      if odd_len
        work_length = len - 1
      else
        work_length = len - 2
      end
      i = 0
      while(i <= work_length)
        work_str += @consonants[rand(@consonants.length)]
        if (@digits[work_str[work_str.length() - 1]] && rand(100) < 23)
          work_str[work_str.length() - 1] = @digits[work_str[work_str.length() - 1]].to_s
        elsif (upcase_any && (rand(100) < 17))
          work_str[work_str.length() - 1] = work_str[work_str.length() - 1].upcase
        end
        i += 1
        work_str += @vowels[rand(@vowels.length)]
        i += 1
        if(spec_char)
          if rand(100) < 18
            work_str += @specials[rand(@specials.length)]
            i += 1
          end
        end
        if i == work_length && work_str.length < work_length
          p "too small..."
          i -= 1
        end
      end
      if upcase_first
        work_str[0] = work_str[0].upcase if @consonants.include?(work_str[0]) || @vowels.include?(work_str[0])
      end
      if work_str.length < len
        diff = len - work_str.length
        while diff > 0
          work_str += rand(9).to_s
          diff -= 1
        end
      elsif work_str.length > len
        diff = work_str.length - len
        while diff > 0
          diff -= 1
          begin
            work_str[work_str.length()] = ""
          rescue NoMethodError => e
            puts "no method err: work: (#{work_str.length}) #{work_str}"
          end
        end
      end
    end
    work_str[0..(len-1)]
  end
end
