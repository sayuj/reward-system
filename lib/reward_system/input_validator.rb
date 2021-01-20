# frozen_string_literal: true

require 'pry'

# Parse and validates the input.
class InputValidator
  VALID_ACTIONS = %w[recommends accepts].freeze

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
    elements = record.split
    validate_datetime(elements[0], elements[1])
    validate_action(elements[3])
    validate_invitee(elements[2], elements[3], elements[4])
  rescue RewardSystemError => e
    error!("Error at line #{index + 1}: #{e.message}.")
  end

  def validate_datetime(date, time)
    Time.parse("#{date} #{time}")
  rescue ArgumentError
    error!('Invalid datetime')
  end

  def validate_action(action)
    error!('Invalid action') unless VALID_ACTIONS.include?(action)
  end

  def validate_invitee(element1, action, element2)
    if action == 'recommends'
      error!('Invitee is missing for recommends action') if element2.nil? || element2.strip.empty?
    else
      error!("#{element1} has no invitation to accept") unless all_invitees.include?(element1)
    end
  end

  def all_invitees
    @all_invitees ||= input.split("\n")
                           .select { |record| record.include?('recommends') }
                           .map { |record| record.split[4] }
  end

  def error!(message)
    raise RewardSystemError, message
  end
end
