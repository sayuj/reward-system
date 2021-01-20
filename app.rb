# frozen_string_literal: true

require 'sinatra'

require './lib/reward_system'

post '/rewards' do
  data = request.body.read
  RewardSystem.new(data).points.to_json
rescue RewardSystemError => e
  { error: e.message }.to_json
end
