# frozen_string_literal: true

require 'sinatra'

require './lib/reward_system'

# The /rewards endpoint can be used in 2 different ways.
# 1. Input as a file
# ```bash
# curl --location --request POST '<base_url>/rewards' \
#     --header 'Content-Type: text/plain' \
#     --data-binary '@/path/to/file'
# ```
#
# 2. Input as raw text
# ```bash
# curl --location --request POST '<base_url>/rewards' \
#     --header 'Content-Type: text/plain' \
#     --data-raw '2018-06-12 09:41 A recommends B
#     2018-06-12 09:41 A recommends B
#     2018-06-14 09:41 B accepts
#     2018-06-16 09:41 B recommends C
#     2018-06-17 09:41 C accepts
#     2018-06-19 09:41 C recommends D
#     2018-06-20 09:41 B recommends D
#     2018-06-25 09:41 D accepts'
# ```
#
# Sample response
# ```json
# {"A":1.75,"B":1.5,"C":1.0}
# ```
post '/rewards' do
  data = request.body.read
  RewardSystem.new(data).points.to_json
rescue RewardSystemError => e
  { error: e.message }.to_json
end

# A simple endpoint with a link to the git repo.
get '/' do
  'Visit ' \
  '<a href="https://github.com/sayuj/reward-system">git repo</a> ' \
  'for more details.'
end
