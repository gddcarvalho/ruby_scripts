class RoundRobin
  attr_reader :number_of_teams
  
  def initialize(number)
    self.number_of_teams = number
    calculate_table
  end

  def number_of_teams=(number)
    if number.even?
      number += 1
    end
    @number_of_teams = number
  end
  
  def number_of_days
      number_of_teams - 1
  end
  
  def calculate_table
    @table = []
    @table[0] = (1..number_of_teams).to_a
    for i in (1..number_of_days) do
      @table[i] = @table[i-1][0..number_of_teams-2].rotate + [@table[i-2][number_of_teams-1]]
    end
  end

  def display
    @table.each_with_index do |array, index|
      printf("day #{index+1} \n") 
      for i in 0..(array.length-1)/2 do
        printf("#{array[i]}-#{array[array.length-1-i]} \n")
      end
    end
  end
end

hello = RoundRobin.new(6)
hello.display
