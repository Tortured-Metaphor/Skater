class Background
  def initialize(window)
    @window = window
    @x = 0
    @cloud_x = 0
    @building_x = 0
    
    @clouds = []
    5.times do |i|
      @clouds << {
        x: rand(GameWindow::WIDTH),
        y: rand(50..200),
        size: rand(30..60)
      }
    end
    
    @buildings = []
    8.times do |i|
      building = {
        x: i * 150,
        width: rand(80..120),
        height: rand(200..400),
        windows: []
      }
      
      # Pre-generate window positions for this building
      (building[:height] / 40).times do |floor|
        (building[:width] / 30).times do |window_x|
          if rand(100) > 30
            building[:windows] << { x: window_x * 30 + 5, y: floor * 40 + 10 }
          end
        end
      end
      
      @buildings << building
    end
  end
  
  def update(speed)
    @x -= speed * 0.5
    @cloud_x -= speed * 0.2
    @building_x -= speed * 0.3
    
    @x = 0 if @x < -GameWindow::WIDTH
    @cloud_x = 0 if @cloud_x < -GameWindow::WIDTH
    @building_x = 0 if @building_x < -GameWindow::WIDTH
  end
  
  def draw
    draw_sky
    draw_clouds
    draw_buildings
    draw_ground
  end
  
  private
  
  def draw_sky
    sky_top = Gosu::Color.argb(255, 135, 206, 235)
    sky_bottom = Gosu::Color.argb(255, 255, 255, 200)
    
    @window.draw_quad(
      0, 0, sky_top,
      GameWindow::WIDTH, 0, sky_top,
      0, GameWindow::HEIGHT - 100, sky_bottom,
      GameWindow::WIDTH, GameWindow::HEIGHT - 100, sky_bottom
    )
  end
  
  def draw_clouds
    @clouds.each do |cloud|
      x = (cloud[:x] + @cloud_x) % (GameWindow::WIDTH + 100) - 50
      
      @window.draw_rect(x, cloud[:y], cloud[:size], cloud[:size] / 2, 
                        Gosu::Color.argb(180, 255, 255, 255))
      @window.draw_rect(x - cloud[:size] / 3, cloud[:y] + 10, cloud[:size] / 2, cloud[:size] / 3,
                        Gosu::Color.argb(180, 255, 255, 255))
      @window.draw_rect(x + cloud[:size] / 2, cloud[:y] + 5, cloud[:size] / 2, cloud[:size] / 2.5,
                        Gosu::Color.argb(180, 255, 255, 255))
    end
  end
  
  def draw_buildings
    @buildings.each_with_index do |building, i|
      x = (building[:x] + @building_x) % (GameWindow::WIDTH * 1.5) - 200
      y = GameWindow::HEIGHT - 100 - building[:height]
      
      color = Gosu::Color.argb(255, 100 + i * 10, 100 + i * 10, 120 + i * 10)
      @window.draw_rect(x, y, building[:width], building[:height], color)
      
      # Draw pre-generated windows
      window_color = Gosu::Color::YELLOW
      building[:windows].each do |window|
        @window.draw_rect(x + window[:x], y + window[:y], 20, 25, window_color)
      end
    end
  end
  
  def draw_ground
    @window.draw_rect(0, GameWindow::HEIGHT - 100, GameWindow::WIDTH, 100, 
                      Gosu::Color.argb(255, 50, 50, 50))
    
    @window.draw_rect(0, GameWindow::HEIGHT - 100, GameWindow::WIDTH, 5,
                      Gosu::Color.argb(255, 80, 80, 80))
    
    20.times do |i|
      x = (i * 60 + @x * 2) % (GameWindow::WIDTH + 60) - 30
      @window.draw_rect(x, GameWindow::HEIGHT - 97, 40, 2, Gosu::Color::YELLOW)
    end
  end
end