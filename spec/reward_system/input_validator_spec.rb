# frozen_string_literal: true

require 'spec_helper'

describe InputValidator do
  context 'with invalid datetime' do
    let(:input) { '2018-06-120 09:41 A recommends B' }

    it 'raise error if the datetime is invalid' do
      error = 'Error at line 1: Invalid datetime.'
      expect { described_class.new(input).call }.to raise_error(error)
    end
  end

  context 'with invalid action' do
    let(:input) { '2018-06-12 09:41 A invalid B' }

    it 'raise error if the action is invalid' do
      error = 'Error at line 1: Invalid action.'
      expect { described_class.new(input).call }.to raise_error(error)
    end
  end

  context 'when invitee is missing for recommends action' do
    let(:input) { '2018-06-12 09:41 A recommends' }

    it 'raise error if invitee is missing for recommends action' do
      error = 'Error at line 1: Invitee is missing for recommends action.'
      expect { described_class.new(input).call }.to raise_error(error)
    end
  end

  context 'when inviter is missing for accepts action' do
    let(:input) { '2018-06-12 09:41 A accepts' }

    it 'raise error if inviter is missing for accepts action' do
      error = 'Error at line 1: A has no invitation to accept.'
      expect { described_class.new(input).call }.to raise_error(error)
    end
  end
end
