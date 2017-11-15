class AcmeGeneticsAnalysis
  def initialize(dna_chain)
    @dna = dna_chain
  end

  def match_consecutive_nucleobases
    tokens = []
    index_of_best_match = nil
    current_index = 0

    value_of_gene = { "ACT" => 1,
                      "CGT" => 2,
                      "AGT" => 4 }

    ['ACT', 'CGT', 'AGT'].each do |gene|

      match = @dna.index(gene, current_index)
      while (match != nil)
        tokens << { index: match, gene: gene }
        current_index = match + 3
        match = @dna.index(gene, current_index)
      end
    end

    tokens.sort_by! { |match| match[:index] }

    for i in 0..(tokens.length - 3)
      if (value_of_gene[tokens[i][:gene]] + value_of_gene[tokens[i+1][:gene]] + value_of_gene[tokens[i+2][:gene]] == 7)
        if (index_of_best_match == nil)
          index_of_best_match = i
        else
          minimum_length = tokens[index_of_best_match+2][:index] + 3 - tokens[index_of_best_match][:index]
          if (tokens[i+2][:index] + 3 - tokens[i][:index]) < minimum_length
            index_of_best_match = i
          end
        end
      end
    end

    return '' unless index_of_best_match
    @dna[tokens[index_of_best_match][:index]..(tokens[index_of_best_match+2][:index]+2)]
  end
end

acmednasolutions = AcmeGeneticsAnalysis.new('ACTACGTTAGTA')
puts acmednasolutions.match_consecutive_nucleobases
