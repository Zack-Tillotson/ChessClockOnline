class Clock < ActiveRecord::Base

  # If the clock is active then subtrack time from the active player
  def updateTimeLeft
    puts "update ya!", self.active, (Time.now - self.updated_at)
    if self.active
      time_diff = (Time.now - updated_at)
      if current_player == 1
        self.player_one_time -= time_diff
        self.player_one_time = 0 if player_one_time < 0
      elsif current_player == 2
        self.player_two_time -= time_diff
        self.player_two_time = 0 if player_two_time < 0
      end
    end
  end

  def player_one_hours
    get_hours player_one_time
  end

  def player_one_mins
    get_mins player_one_time
  end

  def player_one_secs
    get_secs player_one_time
  end

  def player_two_hours
    get_hours player_two_time
  end

  def player_two_mins
    get_mins player_two_time
  end

  def player_two_secs
    get_secs player_two_time
  end

  def switch_current_player
    val = 3 - current_player
    self.current_player = val
  end

private

  def get_hours(secs)
    (secs / 3600).truncate
  end

  def get_mins(secs)
    (secs % 3600 / 60).truncate
  end

  def get_secs(secs)
    (secs % 3600 % 60).truncate
  end
  
end
