class TrickSystem
  def initialize(window)
    @window = window
    @current_trick = nil
    @trick_timer = 0
    @trick_messages = []
    @combo_count = 0
    @combo_timer = 0
  end
  
  def perform_trick(type)
    trick_name = case type
    when :grind
      ["Boardslide", "50-50 Grind", "Nosegrind", "5-0 Grind", "Crooked Grind"].sample
    when :air
      ["Ollie", "Kickflip", "Heelflip", "360 Flip", "Hardflip", "Indy Grab", "Method Air"].sample
    when :manual
      ["Manual", "Nose Manual"].sample
    else
      "Trick"
    end
    
    @current_trick = trick_name
    @trick_timer = 60
    
    if @combo_timer > 0
      @combo_count += 1
    else
      @combo_count = 1
    end
    @combo_timer = 90
    
    points = calculate_points(type)
    @trick_messages << TrickMessage.new(@window, trick_name, points, @combo_count)
  end
  
  def update
    @trick_timer -= 1 if @trick_timer > 0
    @combo_timer -= 1 if @combo_timer > 0
    
    if @combo_timer <= 0
      @combo_count = 0
    end
    
    @trick_messages.each(&:update)
    @trick_messages.reject! { |msg| msg.expired? }
  end
  
  def draw
    if @trick_timer > 0
      trick_text = @current_trick
      trick_text += " x#{@combo_count}" if @combo_count > 1
      
      font = Gosu::Font.new(30)
      x = GameWindow::WIDTH / 2 - (trick_text.length * 8)
      y = 100
      
      font.draw_text(trick_text, x, y, 10, 1, 1, Gosu::Color::YELLOW)
    end
    
    @trick_messages.each(&:draw)
  end
  
  private
  
  def calculate_points(type)
    base_points = case type
    when :grind
      500
    when :air
      300
    when :manual
      200
    else
      100
    end
    
    base_points * @combo_count
  end
end

class TrickMessage
  def initialize(window, text, points, combo)
    @window = window
    @text = "#{text} +#{points}"
    @x = GameWindow::WIDTH / 2
    @y = 150
    @timer = 60
    @combo = combo
    @font = Gosu::Font.new(20)
  end
  
  def update
    @timer -= 1
    @y -= 1 if @timer > 30
  end
  
  def draw
    alpha = @timer < 20 ? (@timer * 12) : 255
    color = Gosu::Color.argb(alpha, 255, 255, 0)
    
    text_width = @text.length * 8
    @font.draw_text(@text, @x - text_width/2, @y, 10, 1, 1, color)
  end
  
  def expired?
    @timer <= 0
  end
end