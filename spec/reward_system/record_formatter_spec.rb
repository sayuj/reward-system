# frozen_string_literal: true

require 'spec_helper'

describe RecordFormatter do
  subject(:records) do
    described_class.new(input).call
  end

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

  it { expect(records[0].inviter).to eq 'A' }
  it { expect(records[0].invitee).to eq 'B' }
  it { expect(records[0].action).to eq 'recommends' }
  it { expect(records[0].datetime).to eq Time.parse('2018-06-12 09:41') }
  it { expect(records[1].inviter).to eq nil }
  it { expect(records[1].invitee).to eq 'B' }
  it { expect(records[1].action).to eq 'accepts' }
end
