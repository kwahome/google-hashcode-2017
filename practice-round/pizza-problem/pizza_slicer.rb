require_relative './slice.rb'
require_relative './solution.rb'

class OutOfPizzaError < StandardError
end

class PizzaEqualizerAlgorithm
    attr_reader :pizza, :slices, :starting_cells

    def initialize(pizza)
        @pizza = pizza
        @slices = []
        @starting_cells = []
    end

    def solve
        while (true) do
            begin
                slice = next_slice
                while(true) do
                    begin
                        if valid_slice?(slice)
                            @slices << slice
                            puts "#{slice.point_top_left.row_index}:#{slice.point_top_left.column_index}"
                            break
                        else
                            if too_big?(slice)
                                raise OutOfPizzaError
                            else
                                increase(slice)
                            end
                            # puts "slice increased! we have now #{slice}"
                        end
                    rescue OutOfPizzaError => no_more_pizza_exception
                        # puts "pizza is finished while increasing it"
                        break
                    end
                end
            rescue OutOfPizzaError => no_more_pizza_exception
            # puts "pizza is finished while trying to cut a new slice"
                break
            end
        end
        puts "I cut #{@slices.count} slices"
        Solution.new(@slices)
        # optimize
    end

    def valid_slice?(slice)
      ret = !too_big?(slice) &&
      mushrooms_in(slice) >= pizza.min_ingredients &&
      tomatoes_in(slice) >= pizza.min_ingredients
    #   puts "I think this slice is #{ret ? '' : 'not'} valid"
      ret
    end

    def too_big?(slice)
        slice.size > pizza.max_slice_size
    end

    def mushrooms_in(slice)
        ingredients_in(slice, 'M')
    end

    def tomatoes_in(slice)
        ingredients_in(slice, 'T')
    end

    def ingredients_in(slice, ingredient)
        count = 0
        (slice.point_top_left.row_index..slice.point_bottom_right.row_index).each do |row_index|
            (slice.point_top_left.column_index..slice.point_bottom_right.column_index).each do |column_index|
                count += 1 if @pizza.grid[row_index][column_index] == ingredient
            end
        end
        count
    end

    def next_slice
        last_cell = @starting_cells.last || [0, 0]
        @pizza.grid[last_cell[0]..-1].each.with_index(last_cell[0]) do |row, row_index|
          row.each_with_index do |column, column_index|
            if is_free?(row_index, column_index)
                slice = Slice.from_coordinates(row_index, column_index, row_index, column_index)
                @starting_cells << [row_index, column_index]
                # puts "I'm giving you the next slice: #{slice}"
                return slice
            end
          end
        end
        raise OutOfPizzaError.new('MOTHER OF GOD! Pizza is finished!!')
    end

    def is_free?(row_index, column_index)
        !@starting_cells.any? { |sc| (sc[0] == row_index) && (sc[1] == column_index) } &&
        !@slices.any? do |slice|
            slice.include?(row_index, column_index)
        end
    end

    def increase(last_slice)
        right = adjacent_right(last_slice)
        # puts "we can add #{right} to your slice"
        if (!right || overlaps?(right))
            last_slice.point_bottom_right.column_index = last_slice.point_top_left.column_index
            bottom = adjacent_bottom(last_slice)
            if (!bottom || overlaps?(bottom))
                raise OutOfPizzaError.new('MOTHER OF GOD! Pizza is finished!!')
            else
                last_slice.join!(bottom)
            end
        else
            last_slice.join!(right)
        end
    end

    def overlaps?(slice)
        @slices.any? { |s| s.overlaps?(slice) }
    end

    def adjacent_right(slice)
        return nil if slice.point_bottom_right.column_index + 1 >= pizza.columns
        Slice.from_coordinates(slice.point_top_left.row_index,
                                slice.point_bottom_right.column_index + 1,
                                slice.point_bottom_right.row_index,
                                slice.point_bottom_right.column_index + 1)
    end

    def adjacent_bottom(slice)
        return nil if slice.point_bottom_right.row_index + 1 >= pizza.rows
        Slice.from_coordinates(slice.point_bottom_right.row_index + 1,
                                slice.point_top_left.column_index,
                                slice.point_bottom_right.row_index + 1,
                                slice.point_bottom_right.column_index)
    end
end