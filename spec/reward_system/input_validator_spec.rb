# frozen_string_literal: true

require 'spec_helper'

describe InputValidator do
  context 'invalid datetime' do
    let(:input) { '2018-06-120 09:41 A recommends B' }

    it 'raise error if the datetime is invalid' do
      expect { InputValidator.new(input).call }.to raise_error('Error at line 1: Invalid datetime.')
    end
  end

  context 'invalid action' do
    let(:input) { '2018-06-12 09:41 A invalid B' }

    it 'raise error if the action is invalid' do
      expect { InputValidator.new(input).call }.to raise_error('Error at line 1: Invalid action.')
    end
  end

  context 'invitee is missing for recommends action' do
    let(:input) { '2018-06-12 09:41 A recommends' }

    it 'raise error if invitee is missing for recommends action' do
      expect do
        InputValidator.new(input).call
      end.to raise_error('Error at line 1: Invitee is missing for recommends action.')
    end
  end

  context 'inviter is missing for accepts action' do
    let(:input) { '2018-06-12 09:41 A accepts' }

    it 'raise error if inviter is missing for accepts action' do
      expect { InputValidator.new(input).call }.to raise_error('Error at line 1: A has no invitation to accept.')
    end
  end
end
