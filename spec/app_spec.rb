require 'spec_helper'

describe 'reward system web app', type: :request do
  it 'returns points JSON' do
    body = %Q{
        2018-06-12 09:41 A recommends B
        2018-06-14 09:41 B accepts
        2018-06-16 09:41 B recommends C
        2018-06-17 09:41 C accepts
        2018-06-19 09:41 C recommends D
        2018-06-23 09:41 B recommends D
        2018-06-25 09:41 D accepts
      }

    post '/rewards', body
    expect(last_response.body).to eq({ A: 1.75, B: 1.5, C: 1.0 }.to_json)
  end

  it 'returns error if the input is invalid' do
    body = '2018-06-120 09:41 A recommends B'

    post '/rewards', body
    expect(last_response.body).to eq({ error: 'Error at line 1: Invalid datetime.' }.to_json)
  end
end
