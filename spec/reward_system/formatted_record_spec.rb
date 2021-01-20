# frozen_string_literal: true

require 'spec_helper'

describe FormattedRecord do
  it 'formats the record for recommends action' do
    record = FormattedRecord.new('2018-06-12 09:41 A recommends B', 0)
    expect(record.index).to eq 0
    expect(record.inviter).to eq  'A'
    expect(record.invitee).to eq  'B'
    expect(record.action).to eq 'recommends'
    expect(record.datetime).to eq Time.parse('2018-06-12 09:41')
  end

  it 'formats the record for accepts action' do
    record = FormattedRecord.new('2018-06-12 09:41 B accepts', 1)
    expect(record.index).to eq 1
    expect(record.inviter).to eq  nil
    expect(record.invitee).to eq  'B'
    expect(record.action).to eq 'accepts'
  end
end
