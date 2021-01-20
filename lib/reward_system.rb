require_relative 'reward_system/record_formatter'
require_relative 'reward_system/formatted_record'
require_relative 'reward_system/reward_tree'
require_relative 'reward_system/reward_tree_node'
require_relative 'reward_system/input_validator'
require_relative 'reward_system/reward_system_error'

class RewardSystem
  attr_reader :input, :customer_tree, :formatted_records
  attr_accessor :reward_tree

  def initialize(input)
    InputValidator.new(input).call
    @formatted_records = RecordFormatter.new(input).call
    @reward_tree = RewardTree.new
    build_reward_tree
  end

  def points
    reward_tree.nodes.transform_values(&:points).reject { |_k, v| v.zero? }
  end

  private

  def build_reward_tree
    formatted_records.each do |record|
      case record.action
      when 'recommends'
        reward_tree.add(
          id: record.invitee,
          inviter: record.inviter,
          accepted: false
        )
      when 'accepts'
        reward_tree.update(id: record.invitee, accepted: true)
      end
    end
  end
end
