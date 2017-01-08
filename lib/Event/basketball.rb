require_relative '../Item/basketball.rb'

module BBall
  
  # Returns true when the ball lands within the net.
  def shoot
    done = false
    success = false
    
    # Current position of the ball.
    current_position = 0
    
    # The character at the ball's current position.
    previous = "·"
    
    board = build_board
    mutex = Mutex.new
    
    print "Press 'enter' to jump..."
    input = gets
    print "\n"
    
    input_thread = Thread.start do
      input = gets
      mutex.lock
      # Find the boundaries of the net for this board.
      left_net_index = board.find_index("\\")
      right_net_index = board.find_index("/")
      # Success if the ball is within the net.
      if (left_net_index && (current_position > left_net_index) &&
          right_net_index && (current_position < right_net_index))
        success = true
      end
      done = true
      mutex.unlock
    end
    
    output_thread = Thread.start do  
      while ((current_position < (board.size - 1)) && (!done))
        
        mutex.lock
        if (current_position < (board.size - 1))
          # Move the ball to the next position.
          temp = board[current_position + 1]
          board[current_position + 1] = "○"
          board[current_position] = previous
          previous = temp
        end
        current_position += 1
      
        print_array(board)
        mutex.unlock
        sleep(0.02)
      end
    end
    
    input_thread.join
    output_thread.join
    
    return success
  end
  
  private
  
    def build_board
      board = ["○"]

      15.times do
        board.push("·")
      end

      # The net (success).
      board.push("\\")
      3.times do
        board.push("·")
      end
      board.push("/")

      4.times do
        board.push("·")
      end
    
      return board
    end
    
    def print_array(board)
      print "\r"
      board.each do |c|
        print c
      end
    end
  
end

class BasketballNet < Event
  def initialize
    super(command: "shoot")
  end
  
  def run(player)
    if (!player.has_item(Basketball.new))
      print "You need a Basketball to shoot here!\n\n"
      return
    end
    
    success = shoot
    print "\n" 
    if success
      puts "Great shot!"
      random = Random.rand(3)
      if random != 0
        puts "Some gold (#{random}) falls on"
        puts "the ground! You pick it up."
        player.gold += random
      end
      print "\n"
    end
    print "Miss!\n\n" unless success
  end
  
  include(BBall)
end