class Generator < ApplicationRecord
  self.abstract_class = true

  attr_accessor :len, :upcase_first, :spec_char, :upcase_any, :add_num
  @consonants = %w[b c d f g h j k l m n p r s t v w x y z]
  @digits = { 'l' => 1, 'e' => 3, 'o' => 0, 'b' => 6, 't' => 7, 'g' => 9, 'c' => 2, 'h' => 5, 'r' => 4, 'd' => 8}
  @vowels = %w[a e i o u]
  @specials = %w[! @ # $ % ^ * & * - + ?]

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
      # Rails.logger.info ">>>> have_num_added: #{have_num_added}, capped_any: #{capped_any}"
      while(i <= work_length)
        work_str += @consonants[rand(@consonants.length - 1)]
        if (add_num && @digits[work_str[work_str.length() - 1]] && rand(100) < 23)
          # Rails.logger.info ">>> add_num replacing work_str char, work_str: #{work_str}"
          have_num_added = true
          work_str[work_str.length() - 1] = @digits[work_str[work_str.length() - 1]].to_s
        elsif (upcase_any && (rand(100) < 17))
          # Rails.logger.info ">>> Upcase_any fired in elsif, work_str: #{work_str}"
          work_str[work_str.length() - 1] = work_str[work_str.length() - 1].upcase
          capped_any = true
        end
        # Rails.logger.info ">>> Added #{work_str[work_str.length() - 1]}"
        i += 1
        work_str += @vowels[rand(@vowels.length - 1)]
        # Rails.logger.info ">> added vowel: #{work_str[work_str.length - 1]}"
        if (add_num && @digits[work_str[work_str.length() - 1]] && rand(100) < 23)
          # Rails.logger.info ">> Replace vowel w/digit..."
          work_str[work_str.length() - 1] = @digits[work_str[work_str.length() - 1]].to_s
          have_num_added = true
        end
        Rails.logger.info ">>> Added #{work_str[work_str.length() - 1]}"
        i += 1
        if spec_char
          if rand(100) < 18
            added_spec_char = true
            work_str += @specials[rand(@specials.length - 1)].to_s
            # Rails.logger.info ">>> Added #{work_str[work_str.length() - 1].to_s}"
            i += 1
          end
        end
        if i == work_length && work_str.length < work_length
          # Rails.logger.info "pw gen string still too small, loop again..."
          i -= 1
        end
      end
      # Rails.logger.info ">>>> Postprocess #{work_str}"
      if upcase_first
        # Rails.logger.info ">> upcase first in work_str"
        work_str[0] = work_str[0].upcase if @consonants.include?(work_str[0]) || @vowels.include?(work_str[0])
      end
      if !have_num_added && add_num
        # Rails.logger.info ">> if !#{have_num_added} && #{add_num} (have_num & add_num)"
        work_str[rand(work_str.length - 1)] = rand(9).to_s
      end
      if !added_spec_char && spec_char
        # Rails.logger.info ">> if !#{added_spec_char} && #{spec_char} (have_num & add_num)"
        work_str[rand(work_str.length() - 1)] = @specials[rand(@specials.length - 1)]
      end
      if upcase_any && work_str.match(/[A-Z]/).nil?
        # Rails.logger.info ">> if #{upcase_any} && !#{capped_any} (upcase_any && !capped_any)"
        j = 0
        k = rand(work_str.length - 1)
        while work_str[k].match(/[a-z]/)
          work_str[k] = work_str[k].upcase
          break
        end
      end
      # Rails.logger.info ">>>> Length adjust #{work_str}"
      if work_str.length < len
        diff = len - work_str.length
        while diff > 0
          if add_num
            work_str += rand(9).to_s
          else
            if rand(100) > 50
              work_str += @vowels[rand(@vowels.length - 1)]
            else
              work_str += @consonants[rand(@consonants.length - 1)]
            end
          end
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
    # Rails.logger.info ">>>>>>>>>>> Done >>>>>>>>>>>>> #{work_str[0..(len-1)]}"
    work_str[0..(len-1)]
  end
end
