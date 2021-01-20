# frozen_string_literal: true

require 'time'

# Represents a reward input record in a formatted way.
#   datetime => datetime of the action performed.
#   action => the action performed - recommends or accepts.
#   inviter => the one who invited the invitee.
#   invitee => the one who received an invitation.
class FormattedRecord
  attr_reader :raw_record, :datetime, :inviter, :invitee, :action

  def initialize(raw_record)
    @raw_record = raw_record
    set_attributes
  end

  private

  def set_attributes
    elements = raw_record.split
    @datetime = format_datetime(elements[0], elements[1])
    @action = elements[3]
    @inviter = extract_inviter(elements[2])
    @invitee = extract_invitee(elements[2], elements[4])
  end

  def format_datetime(date, time)
    Time.parse("#{date} #{time}")
  end

  def extract_inviter(value)
    action == 'recommends' ? value : nil
  end

  def extract_invitee(first, second)
    action == 'accepts' ? first : second
  end
end
