module PasswordsHelper
  @letter_freq = [
    {"a" => 0.08167},
    {"e" => 0.12702},
    {"b" => 0.01492},
    {"c" => 0.02782},
    {"d" => 0.04253},
    {"o" => 0.07507},
    {"i" => 0.06966},
    {"f" => 0.02228},
    {"g" => 0.02015},
    {"h" => 0.06094},
    {"j" => 0.00153},
    {"k" => 0.00772},
    {"l" => 0.04025},
    {"m" => 0.02406},
    {"n" => 0.06749},
    {"p" => 0.01929},
    {"q" => 0.00095},
    {"r" => 0.05987},
    {"s" => 0.06327},
    {"t" => 0.09056},
    {"u" => 0.02758},
    {"v" => 0.00978},
    {"w" => 0.02360},
    {"x" => 0.00150},
    {"y" => 0.01974},
    {"z" => 0.00074} ]

  # Frequency-ordered list of character pair
  def pair_freq(check_pair = nil)
    ordered_pairs = %w{th he in er an re on at nd or ed en es te ar ti al st of it is as to nt ng le se ri de co ro me ra ve io ic ou ha ea hi ne la li ma ce ch ca si om ll }
    ordered_bigrams = %w{th he in en nt re er an ti es on at se nd or ar al te co de to ra et ed it sa em ro}

    unless check_pair.nil?
      if ordered_pairs.include? check_pair
        ordered_pairs.index(check_pair)
      else
        nil
      end
    end
  end

  def char_freq(ch = nil)
    unless ch.nil?
      @letter_freq.collect{|c| c[ch]}.find{|q| !q.nil?}
    end
  end
end
