require 'pry'

class InputValidator
  VALID_ACTIONS = ['recommends', 'accepts']

  attr_reader :input

  def initialize(input)
    @input = input
  end

  def call
    input.split("\n").each_with_index do |record, index|
      record.strip!
      next if record.empty?

      validate(record, index)
    end
  end

  private

  def validate(record, index)
    elements = record.split(' ')
    validate_datetime(elements[0], elements[1])
    validate_action(elements[3])
    validate_invitee(elements[2], elements[3], elements[4])
  rescue => e
    raise "Error at line #{index + 1}: #{e.message}."
  end

  def validate_datetime(date, time)
    Time.parse("#{date} #{time}")
  rescue
    raise 'Invalid datetime'
  end

  def validate_action(action)
    raise 'Invalid action' unless VALID_ACTIONS.include?(action)
  end

  def validate_invitee(element1, action, element2)
    case action
    when 'recommends'
      raise 'Invitee is missing for recommends action' if element2.nil? || element2.strip.empty?
    when 'accepts'
      unless all_invitees.include?(element1)
        raise "#{element1} has no invitation to accept"
      end
    end
  end

  def all_invitees
    @all_invitees ||= input.split("\n")
      .select { |record| record.include?('recommends') }
      .map { |record| record.split(' ')[4] }
  end
end
