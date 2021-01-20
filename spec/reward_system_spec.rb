# frozen_string_literal: true

require 'spec_helper'

describe RewardSystem do
  context 'sorted input' do
    let(:input) do
      %(
        2018-06-12 09:41 A recommends B
        2018-06-14 09:41 B accepts
        2018-06-16 09:41 B recommends C
        2018-06-17 09:41 C accepts
        2018-06-19 09:41 C recommends D
        2018-06-23 09:41 B recommends D
        2018-06-25 09:41 D accepts
      )
    end

    it 'returns the reward points for each customers' do
      points = RewardSystem.new(input).points
      expect(points).to eq({ 'A' => 1.75, 'B' => 1.5, 'C' => 1.0 })
    end
  end

  context 'unsorted input' do
    let(:input) do
      %(
        2018-06-12 09:41 A recommends B
        2018-06-14 09:41 B accepts
        2018-06-16 09:41 B recommends C
        2018-06-17 09:41 C accepts
        2018-06-23 09:41 B recommends D
        2018-06-19 09:41 C recommends D
        2018-06-25 09:41 D accepts
      )
    end

    it 'returns the reward points for each customers' do
      points = RewardSystem.new(input).points
      expect(points).to eq({ 'A' => 1.75, 'B' => 1.5, 'C' => 1.0 })
    end
  end

  context 'multiple accepts by same invitee' do
    let(:input) do
      %(
        2018-06-12 09:41 A recommends B
        2018-06-14 09:41 B accepts
        2018-06-16 09:41 B recommends C
        2018-06-17 09:41 C accepts
        2018-06-23 09:41 B recommends D
        2018-06-19 09:41 C recommends D
        2018-06-25 09:41 D accepts
        2018-06-25 09:41 D accepts
      )
    end

    it 'returns the reward points for each customers' do
      points = RewardSystem.new(input).points
      expect(points).to eq({ 'A' => 1.75, 'B' => 1.5, 'C' => 1.0 })
    end
  end
end
