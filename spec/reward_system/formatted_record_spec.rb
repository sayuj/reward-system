# frozen_string_literal: true

require 'spec_helper'

describe FormattedRecord do
  context 'with recommends action' do
    subject(:record) do
      described_class.new('2018-06-12 09:41 A recommends B', 0)
    end

    it { expect(record.index).to eq 0 }
    it { expect(record.inviter).to eq 'A' }
    it { expect(record.invitee).to eq 'B' }
    it { expect(record.action).to eq 'recommends' }
    it { expect(record.datetime).to eq Time.parse('2018-06-12 09:41') }
  end

  context 'with accepts action' do
    subject(:record) do
      described_class.new('2018-06-12 09:41 B accepts', 1)
    end

    it { expect(record.index).to eq 1 }
    it { expect(record.inviter).to eq nil }
    it { expect(record.invitee).to eq 'B' }
    it { expect(record.action).to eq 'accepts' }
  end
end
