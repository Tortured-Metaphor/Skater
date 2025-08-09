class Obstacle
  attr_reader :x, :y, :width, :height, :type
  
  def initialize(window, x, type)
    @window = window
    @x = x
    @type = type
    
    case @type
    when :rail
      @width = 150
      @height = 30
      @y = GameWindow::GROUND_Y - @height
      @color = Gosu::Color::GRAY
    when :ramp
      @width = 100
      @height = 80
      @y = GameWindow::GROUND_Y - @height
      @color = Gosu::Color.argb(255, 139, 69, 19)
    when :box
      @width = 60
      @height = 60
      @y = GameWindow::GROUND_Y - @height
      @color = Gosu::Color.argb(255, 165, 42, 42)
    end
  end
  
  def self.random(window, x)
    types = [:rail, :ramp, :box]
    new(window, x, types.sample)
  end
  
  def update(speed)
    @x -= speed
  end
  
  def draw
    case @type
    when :rail
      @window.draw_rect(@x, @y, @width, @height, @color)
      @window.draw_rect(@x, @y - 5, 10, @height + 10, Gosu::Color.argb(255, 192, 192, 192))
      @window.draw_rect(@x + @width - 10, @y - 5, 10, @height + 10, Gosu::Color.argb(255, 192, 192, 192))
    when :ramp
      points = [
        @x, @y + @height,
        @x + @width, @y + @height,
        @x + @width, @y,
        @x, @y + @height
      ]
      @window.draw_triangle(
        points[0], points[1], @color,
        points[2], points[3], @color,
        points[4], points[5], @color
      )
    when :box
      @window.draw_rect(@x, @y, @width, @height, @color)
      @window.draw_rect(@x + 5, @y + 5, @width - 10, @height - 10, Gosu::Color.argb(255, 185, 62, 62))
    end
  end
end