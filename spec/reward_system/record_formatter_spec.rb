require 'spec_helper'

describe RecordFormatter do
  let(:input) do
    %Q{
      2018-06-12 09:41 A recommends B
      2018-06-14 09:41 B accepts
      2018-06-16 09:41 B recommends C
      2018-06-17 09:41 C accepts
      2018-06-19 09:41 C recommends D
      2018-06-23 09:41 B recommends D
      2018-06-25 09:41 D accepts
    }
  end

  subject do
    RecordFormatter.new(input).call
  end

  it 'returns array of formatted records' do
    expect(subject[0].inviter).to eq  'A'
    expect(subject[0].invitee).to eq  'B'
    expect(subject[0].action).to eq  'recommends'
    expect(subject[0].datetime).to eq  Time.parse('2018-06-12 09:41')
    expect(subject[1].inviter).to eq  nil
    expect(subject[1].invitee).to eq  'B'
    expect(subject[1].action).to eq  'accepts'
  end
end
