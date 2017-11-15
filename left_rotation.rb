class LeftRotation
  def initialize(number_of_elements, left_rotations)
    @number_of_elements = number_of_elements.to_i
    @left_rotations = left_rotations.to_i % number_of_elements.to_i
  end

  def rotate_left
    elements_array = []
    rotated_array = []
    aux = 0
    
    for i in 0..@number_of_elements
        elements_array[i] = i
    end

    for j in 0..@number_of_elements
        rotated_array[j] = elements_array[j + @left_rotations]
    end

    @left_rotations.downto(1).each do | x |
        rotated_array[elements_array.size.to_i - x] = elements_array[aux]
        aux = aux + 1
    end

    puts "Initial array: " + elements_array.to_s
    puts "Array after rotation: " + rotated_array.to_s
  end
end

rotate = LeftRotation.new(5, 2)
rotate.rotate_left
