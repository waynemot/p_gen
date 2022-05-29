class Generator < ApplicationRecord
  self.abstract_class = true

  attr_accessor :len, :upcase_first, :spec_char, :upcase_any, :add_num
  @consonants = %w[b c d f g h j k l m n p r s t v w x y z]
  @digits = { 'l' => 1, 'e' => 3, 'o' => 0, 'b' => 6, 't' => 7, 'g' => 9, 'c' => 2, 'h' => 5, 'r' => 4, 'd' => 8}
  @vowels = %w[a e i o u]
  @specials = %w[! @ # $ % ^ * & * - + ?]
  # Weight/percentage at which random actions are taken during the password algorithm
  # adjust frequency of occurrence here
  @weights = [{'add_num' => 23},{'upcase_any' => 17},{'spec_char' => 18}]

  def self.gen(len = 8, upcase_first = false, add_num = false, spec_char = false, upcase_any = false)
    # Rails.logger.info "upcase_first: #{upcase_first} is_a string? #{upcase_first.is_a?(String)}"
    # Rails.logger.info "add_num: #{add_num} spec_char: #{spec_char}, upcase_any: #{upcase_any}"
    # Normalize form data passed
    if upcase_first && upcase_first.eql?("1") || upcase_first == 1
      upcase_first = true
    else
      upcase_first = false
    end
    if upcase_any && upcase_any.eql?("1") || upcase_any == 1
      upcase_any = true
    else
      upcase_any = false
    end
    if spec_char && spec_char.eql?("1") || spec_char == 1
      spec_char = true
    else
      spec_char = false
    end
    if add_num && add_num.eql?("1") || add_num == 1
      add_num = true
    else
      add_num = false
    end
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
      have_num_added = add_num ? false : true
      added_spec_char = spec_char ? false : true
      capped_any = !upcase_first || (upcase_any ? false : true)
      while i <= work_length
        work_str += @consonants[rand(@consonants.length - 1)]
        if add_num && @digits[work_str[work_str.length - 1]] && rand(100) < (@weights.collect{ |w| w['add_num'].nil? ? 0 : w['add_num'].to_i }.inject(:+))
          work_str[work_str.length - 1] = @digits[work_str[work_str.length - 1]].to_s
          have_num_added = true
        elsif upcase_any && rand(100) < (@weights.collect{ |w| w['upcase_any'].nil? ? 0 : w['upcase_any'] }.inject(:+))
          work_str[work_str.length - 1] = work_str[work_str.length - 1].upcase
          capped_any = true
        end
        i += 1
        work_str += @vowels[rand(@vowels.length - 1)]
        i += 1
        if upcase_any && rand(100) < (@weights.collect{ |w| w['upcase_any'].nil? ? 0 : w['upcase_any'].to_i }.inject(:+))
          work_str[work_str.length - 1] = work_str[work_str.length - 1].upcase
        end
        if add_num && @digits[work_str[work_str.length - 1]] && rand(100) < (@weights.collect{ |w| w['add_num'].nil? ? 0 : w['add_num'] }.inject(:+))
          (work_str[work_str.length - 1] = @digits[work_str[work_str.length - 1]].to_s)
          have_num_added = true
        end
        if spec_char
          if rand(100) < @weights.collect{ |w| w['spec_char'].nil? ? 0 : w['spec_char'].to_i }.inject(:+)
            added_spec_char = true
            work_str += @specials[rand(@specials.length - 1)].to_s
            i += 1
          end
        end
        if i == work_length && work_str.length < work_length
          i -= 1
        end
      end
      Rails.logger.info ">>>> Postprocess #{work_str}"
      # Ensure the generated word complies with all constraints
      # and apply first_char capitalization
      if upcase_first
        if @consonants.include?(work_str[0])
          work_str[0] = work_str[0].try(:upcase)
          capped_any = true
        end
      end

      Rails.logger.info ">>>> Length adjust #{work_str}: #{work_str.length} < #{len}"
      if work_str.length < len
        diff = len - work_str.length
        while diff > 0
          if add_num # prefer adding number to short inputs
            work_str += rand(9).to_s
          else
            if rand(100) > 50 # Coin toss vowel/consonant
              work_str += @vowels[rand(@vowels.length - 1)]
            else
              work_str += @consonants[rand(@consonants.length - 1)]
            end
          end
          diff -= 1
        end
      elsif work_str.length > len
        diff = work_str.length - len
        # Rails.logger.info "diff: #{work_str.length} - #{len} = #{diff}"
        while diff > 0
          begin
            done = false
            while !done
              cut_pt = rand(work_str.length-1)
              # Don't delete specials/numbers if selected
              if  spec_char && !@specials.include?(work_str[cut_pt])
                if add_num && !((work_str[cut_pt]) !~ /\D/)
                  done = true
                  work_str = work_str.sub(/#{work_str[cut_pt]}/,"")
                end
              end
            end
            diff = work_str.length - len
          rescue NoMethodError => e
            Rails.logger.error "no method err: work: (#{work_str.length}) #{work_str}"
          end
          Rails.logger.info "shorter string: #{work_str}"
        end
      end
      if  add_num && !have_num_added
        work_str[rand(work_str.length - 1)] = rand(9).to_s
      end
      if  spec_char && !added_spec_char
        work_str[rand(work_str.length - 1)] = @specials[rand(@specials.length - 1)]
      end
      # Rails.logger.info ">>> upcase_any: #{upcase_any} work_str test: #{work_str.match(/[A-Z]/)}"
      if upcase_any && work_str.match(/[A-Z]/).nil?
        Rails.logger.info ">> if #{upcase_any} && !#{capped_any} (upcase_any && !capped_any)"
        j = 0
        done = false
        until done
          k = rand(work_str.length - 1)
          if work_str[k].match(/[a-z]/)
            work_str[k] = work_str[k].try(:upcase)
            Rails.logger.info ">> replaced #{work_str[k]}"
            done = true
          end
        end
      end
    end
    # Rails.logger.info ">>>>>>>>>>> Done >>>>>>>>>>>>> #{work_str[0..(len-1)]}"
    work_str[0..(len-1)]
  end
end
