require 'shoes'

class GameOfLife
  CELL_SIZE = 10

  attr_reader :grid

  def initialize(width, height)
    @grid_width = width
    @grid_height = height
    @grid = Array.new(@grid_height) { Array.new(@grid_width, false) }
  end

  def neighbors(x, y)
    neighbors = []
    (-1..1).each do |dx|
      (-1..1).each do |dy|
        next if dx.zero? && dy.zero?

        new_x = (x + dx + @grid_width) % @grid_width
        new_y = (y + dy + @grid_height) % @grid_height
        next if @grid[new_y].nil? || @grid[new_y][new_x].nil?

        neighbors << @grid[new_y][new_x]
      end
    end
    neighbors
  end

  def update_cell(x, y)
    live_neighbors = neighbors(x, y).count(true)
    @grid[y][x] = if @grid[y][x]
                     live_neighbors == 2 || live_neighbors == 3
                   else
                     live_neighbors == 3
                   end
  end

  def update_grid
    new_grid = Array.new(@grid_height) { Array.new(@grid_width, false) }
    (0...@grid_height).each do |y|
      (0...@grid_width).each do |x|
        update_cell(x, y)
        new_grid[y][x] = @grid[y][x]
      end
    end
    @grid.replace(new_grid)
  end

  def add_glider(x, y)
    @grid[y][x + 1] = true
    @grid[y + 1][x + 2] = true
    @grid[y + 2][x] = true
    @grid[y + 2][x + 1] = true
    @grid[y + 2][x + 2] = true
  end
end

$game_of_life = GameOfLife.new(125, 75)

# Seeds
$game_of_life.add_glider(21, 3)
$game_of_life.add_glider(21, 4)
$game_of_life.add_glider(21, 5)
$game_of_life.add_glider(22, 3)
$game_of_life.add_glider(22, 4)
$game_of_life.add_glider(22, 5)
$game_of_life.add_glider(23, 2)
$game_of_life.add_glider(23, 6)
$game_of_life.add_glider(25, 1)
$game_of_life.add_glider(25, 2)
$game_of_life.add_glider(25, 6)
$game_of_life.add_glider(25, 7)
$game_of_life.add_glider(35, 3)
$game_of_life.add_glider(35, 4)
$game_of_life.add_glider(36, 3)
$game_of_life.add_glider(36, 4)

class GameOfLifeApp
  def start
    Shoes.app(title: 'Game Of Life', width: $game_of_life.grid[0].size * GameOfLife::CELL_SIZE, height: $game_of_life.grid.size * GameOfLife::CELL_SIZE) do
      @canvas = self
      background white

      draw_grid = lambda do
        @canvas.clear do
          $game_of_life.grid.each_with_index do |row, y|
            row.each_with_index do |cell, x|
              fill black if cell
              rect left: x * GameOfLife::CELL_SIZE, top: y * GameOfLife::CELL_SIZE, width: GameOfLife::CELL_SIZE, height: GameOfLife::CELL_SIZE if cell
            end
          end
        end
      end

      animate(10) do
        $game_of_life.update_grid
        draw_grid.call
      end
    end
  end
end

GameOfLifeApp.new.start
