require 'gosu'

class GameWindow < Gosu::Window
  WIDTH = 1024
  HEIGHT = 768
  GROUND_Y = HEIGHT - 100
  
  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Skater Game"
    
    @font = Gosu::Font.new(20)
    @large_font = Gosu::Font.new(40)
    
    @skateboarder = Skateboarder.new(self)
    @background = Background.new(self)
    @trick_system = TrickSystem.new(self)
    
    @obstacles = []
    @score = 0
    @distance = 0
    @game_speed = 5
    @obstacle_timer = 0
    
    generate_initial_obstacles
  end
  
  def update
    @distance += @game_speed
    @score += 1 if Gosu.milliseconds % 10 == 0
    
    @skateboarder.update
    @background.update(@game_speed)
    @trick_system.update
    
    update_obstacles
    check_collisions
    
    @game_speed = 5 + (@distance / 5000.0)
    @game_speed = [@game_speed, 15].min
  end
  
  def draw
    @background.draw
    
    @obstacles.each(&:draw)
    @skateboarder.draw
    @trick_system.draw
    
    draw_ui
  end
  
  def button_down(id)
    case id
    when Gosu::KB_SPACE
      @skateboarder.jump
    when Gosu::KB_ESCAPE
      close
    end
  end
  
  private
  
  def generate_initial_obstacles
    3.times do |i|
      x = WIDTH + (i * 400)
      @obstacles << Obstacle.random(self, x)
    end
  end
  
  def update_obstacles
    @obstacles.each { |obs| obs.update(@game_speed) }
    @obstacles.reject! { |obs| obs.x < -100 }
    
    @obstacle_timer -= 1
    
    if @obstacle_timer <= 0 && @obstacles.size < 5
      last_x = @obstacles.map(&:x).max || WIDTH
      if last_x < WIDTH + 200
        @obstacles << Obstacle.random(self, WIDTH + 300)
        @obstacle_timer = rand(60..120)
      end
    end
  end
  
  def check_collisions
    @obstacles.each do |obstacle|
      if @skateboarder.collides_with?(obstacle)
        if @skateboarder.grounded? && !@skateboarder.on_obstacle?
          if obstacle.type == :rail
            @skateboarder.start_grind(obstacle)
            @trick_system.perform_trick(:grind)
            @score += 500
          elsif obstacle.type == :ramp
            @skateboarder.launch_from_ramp(obstacle)
            @trick_system.perform_trick(:air)
            @score += 300
          end
        elsif @skateboarder.on_obstacle? && @skateboarder.current_obstacle != obstacle
          @skateboarder.end_grind
        end
      end
    end
    
    if @skateboarder.on_obstacle? && !@skateboarder.collides_with?(@skateboarder.current_obstacle)
      @skateboarder.end_grind
    end
  end
  
  def draw_ui
    @font.draw_text("Score: #{@score}", 10, 10, 10, 1, 1, Gosu::Color::WHITE)
    @font.draw_text("Distance: #{@distance}m", 10, 35, 10, 1, 1, Gosu::Color::WHITE)
    @font.draw_text("Speed: #{@game_speed.round(1)}x", 10, 60, 10, 1, 1, Gosu::Color::WHITE)
  end
end