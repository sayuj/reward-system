class RecordFormatter
  attr_reader :input 

  def initialize(input)
    @input = input
  end

  def call 
    input.split("\n").map do |record|
      record.strip!
      next if record.empty?

      FormattedRecord.new(record)
    end.compact.sort_by(&:datetime)
  end
end
