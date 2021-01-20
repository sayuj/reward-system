require_relative 'record_formatter'
require_relative 'formatted_record'
require_relative 'reward_tree'
require_relative 'reward_tree_node'

class RewardSystem
  attr_reader :input, :customer_tree, :formatted_records
  attr_accessor :reward_tree

  def initialize(input)
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
