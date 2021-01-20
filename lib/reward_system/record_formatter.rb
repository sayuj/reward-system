# frozen_string_literal: true

# Parse the input and format each record.
class RecordFormatter
  attr_reader :input

  def initialize(input)
    @input = input
  end

  def call
    records = input.split("\n")
    formatted_records = records.each_with_index.map do |record, index|
      format_record(index, record.strip)
    end.compact
    sort(formatted_records)
  end

  private

  def format_record(index, record)
    FormattedRecord.new(record, index) unless record.empty?
  end

  def sort(formatted_records)
    formatted_records.sort do |first, second|
      [first.datetime, first.index] <=> [second.datetime, second.index]
    end
  end
end
