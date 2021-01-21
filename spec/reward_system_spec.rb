# frozen_string_literal: true

require 'spec_helper'

describe RewardSystem do
  context 'with sorted input' do
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
      points = described_class.new(input).points
      expect(points).to eq({ 'A' => 1.75, 'B' => 1.5, 'C' => 1.0 })
    end
  end

  context 'with unsorted input' do
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
      points = described_class.new(input).points
      expect(points).to eq({ 'A' => 1.75, 'B' => 1.5, 'C' => 1.0 })
    end
  end

  context 'when multiple accepts by same invitee' do
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
      points = described_class.new(input).points
      expect(points).to eq({ 'A' => 1.75, 'B' => 1.5, 'C' => 1.0 })
    end
  end

  context 'when recommends and accepts are given at the same time' do
    context 'when recommends listed above accepts in the command list' do
      let(:input) do
        %(
          2018-06-12 09:41 A recommends B
          2018-06-12 09:41 B accepts
        )
      end

      it 'returns the reward points for each customers' do
        points = described_class.new(input).points
        expect(points).to eq({ 'A' => 1 })
      end
    end

    context 'when accepts listed above recommends in the command list' do
      let(:input) do
        %(
          2018-06-12 09:41 B accepts
          2018-06-12 09:41 A recommends B
        )
      end

      it 'returns the reward points for each customers' do
        expect do
          described_class.new(input).points
        end.to raise_error('B has no invitation to accept')
      end
    end
  end

  context 'when existing customer tries to accept an invitation' do
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
      points = described_class.new(input).points
      expect(points).to eq({ 'A' => 1.5, 'B' => 1 })
    end
  end

  context 'when one receives invitation and invite other without accepting' do
    let(:input) do
      %(
        2018-06-12 09:41 A recommends B
        2018-06-16 09:41 B recommends C
        2018-06-17 09:41 B accepts
        2018-06-18 09:41 C accepts
      )
    end

    it 'ignore accepts command for existing customer' do
      points = described_class.new(input).points
      expect(points).to eq({ 'B' => 1.0 })
    end
  end
end
