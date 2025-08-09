class Skateboarder
  attr_reader :x, :y, :width, :height, :current_obstacle
  
  GRAVITY = 0.8
  JUMP_STRENGTH = -15
  GRIND_SPEED = 1
  
  def initialize(window)
    @window = window
    @x = 200
    @y = GameWindow::GROUND_Y - 60
    @width = 40
    @height = 60
    
    @velocity_y = 0
    @grounded = true
    @on_obstacle = false
    @current_obstacle = nil
    @rotation = 0
    @trick_rotation = 0
    @grind_animation = 0
    @flip_animation = 0
    @trick_type = nil
    @leg_angle = 0
    @arm_angle = 0
  end
  
  def update
    unless @on_obstacle
      @velocity_y += GRAVITY
      @y += @velocity_y
      
      if @y >= GameWindow::GROUND_Y - @height
        @y = GameWindow::GROUND_Y - @height
        @velocity_y = 0
        @grounded = true
        @trick_rotation = 0
        @flip_animation = 0
        @trick_type = nil
        @leg_angle = 0
        @arm_angle = 0
      else
        @grounded = false
      end
      
      if @velocity_y < 0 && @trick_type == :air
        @trick_rotation += 15
        @flip_animation += 20
      end
    else
      @y = @current_obstacle.y - @height
      @grounded = true
      @grind_animation += 10
      @leg_angle = Math.sin(@grind_animation * Math::PI / 180) * 20
      @arm_angle = Math.cos(@grind_animation * Math::PI / 180) * 30
    end
    
    @rotation = @trick_rotation % 360
  end
  
  def draw
    color = @on_obstacle ? Gosu::Color::YELLOW : Gosu::Color::WHITE
    
    Gosu.translate(@x + @width/2, @y + @height/2) do
      main_rotation = @trick_type == :air ? @flip_animation : @rotation
      Gosu.rotate(main_rotation) do
        # Head (circle approximated with a square)
        head_size = 12
        @window.draw_rect(-head_size/2, -@height/2, head_size, head_size, color)
        
        # Body (torso)
        body_start_y = -@height/2 + head_size
        body_height = 20
        @window.draw_rect(-1, body_start_y, 2, body_height, color)
        
        # Arms - animated during tricks
        arm_y = body_start_y + 5
        if @on_obstacle || @trick_type == :air
          # Left arm animated
          Gosu.rotate(@arm_angle, -12, arm_y) do
            @window.draw_rect(-12, arm_y, 12, 2, color)
          end
          # Right arm animated
          Gosu.rotate(-@arm_angle, 12, arm_y) do
            @window.draw_rect(0, arm_y, 12, 2, color)
          end
        else
          @window.draw_rect(-12, arm_y, 24, 2, color)  # Normal horizontal arms
        end
        
        # Legs - animated during grinds
        leg_start_y = body_start_y + body_height
        leg_length = @height/2 - head_size - body_height
        
        if @on_obstacle
          # Animated crouched legs for grinding
          # Left leg bent
          Gosu.rotate(@leg_angle, -6, leg_start_y) do
            @window.draw_rect(-6, leg_start_y, 2, leg_length/2, color)
          end
          @window.draw_rect(-8 + @leg_angle/10, leg_start_y + leg_length/2, 2, leg_length/2, color)
          
          # Right leg bent
          Gosu.rotate(-@leg_angle, 4, leg_start_y) do
            @window.draw_rect(4, leg_start_y, 2, leg_length/2, color)
          end
          @window.draw_rect(6 - @leg_angle/10, leg_start_y + leg_length/2, 2, leg_length/2, color)
        elsif @trick_type == :air
          # Legs tucked during air tricks
          tuck_angle = Math.sin(@flip_animation * Math::PI / 180) * 45
          Gosu.rotate(tuck_angle, 0, leg_start_y) do
            @window.draw_rect(-6, leg_start_y, 2, leg_length * 0.7, color)
            @window.draw_rect(4, leg_start_y, 2, leg_length * 0.7, color)
          end
        else
          # Normal standing legs
          @window.draw_rect(-6, leg_start_y, 2, leg_length/2, color)
          @window.draw_rect(-8, leg_start_y + leg_length/2, 2, leg_length/2, color)
          @window.draw_rect(4, leg_start_y, 2, leg_length/2, color)
          @window.draw_rect(6, leg_start_y + leg_length/2, 2, leg_length/2, color)
        end
        
        # Skateboard - spins independently during flips
        board_y = @height/2 - 5
        board_rotation = @trick_type == :air ? @flip_animation * 2 : 0
        Gosu.rotate(board_rotation, 0, board_y + 2) do
          @window.draw_rect(-@width/2, board_y, @width, 4, Gosu::Color::RED)
          # Wheels
          @window.draw_rect(-@width/2 + 5, board_y + 4, 6, 6, Gosu::Color::BLACK)
          @window.draw_rect(@width/2 - 11, board_y + 4, 6, 6, Gosu::Color::BLACK)
        end
      end
    end
    
    # Draw sparks when grinding
    if @on_obstacle && @current_obstacle && @current_obstacle.type == :rail
      spark_count = 3
      spark_count.times do |i|
        if rand(100) > 50
          spark_x = @x + rand(-10..10)
          spark_y = @y + @height + rand(-5..5)
          @window.draw_rect(spark_x, spark_y, 2, 2, Gosu::Color::YELLOW)
          @window.draw_rect(spark_x - 1, spark_y - 1, 4, 1, Gosu::Color.argb(128, 255, 200, 0))
        end
      end
    end
  end
  
  def jump
    if @grounded
      @velocity_y = JUMP_STRENGTH
      @grounded = false
      
      if @on_obstacle
        @velocity_y *= 1.3
        end_grind
      end
    end
  end
  
  def start_grind(obstacle)
    @on_obstacle = true
    @current_obstacle = obstacle
    @velocity_y = 0
    @trick_type = :grind
    @grind_animation = 0
  end
  
  def end_grind
    @on_obstacle = false
    @current_obstacle = nil
    @trick_type = nil
    @leg_angle = 0
    @arm_angle = 0
  end
  
  def launch_from_ramp(obstacle)
    @velocity_y = JUMP_STRENGTH * 1.5
    @grounded = false
    @trick_rotation = 0
    @flip_animation = 0
    @trick_type = :air
  end
  
  def collides_with?(obstacle)
    @x < obstacle.x + obstacle.width &&
    @x + @width > obstacle.x &&
    @y < obstacle.y + obstacle.height &&
    @y + @height > obstacle.y
  end
  
  def grounded?
    @grounded
  end
  
  def on_obstacle?
    @on_obstacle
  end
end