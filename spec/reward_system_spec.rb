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

  context 'recommends and accepts at same time' do
    context 'recommends listed above accepts in the command list' do
      let(:input) do
        %(
          2018-06-12 09:41 A recommends B
          2018-06-12 09:41 B accepts
        )
      end

      it 'returns the reward points for each customers' do
        points = RewardSystem.new(input).points
        expect(points).to eq({ 'A' => 1 })
      end
    end

    context 'accepts listed above recommends in the command list' do
      let(:input) do
        %(
          2018-06-12 09:41 B accepts
          2018-06-12 09:41 A recommends B
        )
      end

      it 'returns the reward points for each customers' do
        expect { RewardSystem.new(input).points }.to raise_error('B has no invitation to accept')
      end
    end
  end

  context 'someone recommends an existing customer and the customer tries to accept' do
    let(:input) do
      %(
        2018-06-12 09:41 A recommends B
        2018-06-14 09:41 B accepts
        2018-06-16 09:41 B recommends C
        2018-06-17 09:41 C accepts
        2018-06-19 09:41 C recommends A
        2018-06-25 09:41 A accepts
      )
    end

    it 'ignore invitation to existing customer and calculate points' do
      points = RewardSystem.new(input).points
      expect(points).to eq({ 'A' => 1.5, 'B' => 1 })
    end
  end
end
