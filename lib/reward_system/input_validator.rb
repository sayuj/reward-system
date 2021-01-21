# frozen_string_literal: true

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
    validate_invitee(elements[3], elements[4])
    validate_invitation(elements[3], elements[2])
  rescue RewardSystemError => e
    error!("Error at line #{index + 1}: #{e.message}.")
  end

  def validate_datetime(date, time)
    Time.parse("#{date} #{time}")
  rescue ArgumentError
    error!('Invalid datetime')
  end

  def validate_action(action)
    return if VALID_ACTIONS.include?(action)

    error!('Invalid action')
  end

  def validate_invitee(action, invitee)
    return unless invitee_missing?(action, invitee)

    error!('Invitee is missing for recommends action')
  end

  def validate_invitation(action, invitee)
    return unless no_invitation?(action, invitee)

    error!("#{invitee} has no invitation to accept")
  end

  def invitee_missing?(action, invitee)
    action == 'recommends' && (invitee.nil? || invitee.strip.empty?)
  end

  def no_invitation?(action, invitee)
    action == 'accepts' && !all_invitees.include?(invitee)
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
