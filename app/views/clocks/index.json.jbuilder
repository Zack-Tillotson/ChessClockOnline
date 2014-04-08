json.array!(@clocks) do |clock|
  json.extract! clock, :id, :active, :current_player, :player_one_time, :player_two_time, :key
  json.url clock_url(clock, format: :json)
end
