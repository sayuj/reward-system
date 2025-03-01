# frozen_string_literal: true

require_relative 'reward_system/record_formatter'
require_relative 'reward_system/formatted_record'
require_relative 'reward_system/reward_tree'
require_relative 'reward_system/reward_tree_node'
require_relative 'reward_system/input_validator'
require_relative 'reward_system/reward_system_error'

# Validate and converts the raw input of rewards and
# calculate the reward points.
class RewardSystem
  attr_reader :input, :customer_tree, :records

  def initialize(input)
    InputValidator.new(input).call
    @records = RecordFormatter.new(input).call
    build_reward_tree
  end

  # Get the points from the reward tree and exclude the
  # elements with zero points.
  def points
    reward_tree.nodes.transform_values(&:points).reject { |_k, v| v.zero? }
  end

  private

  def build_reward_tree
    records.each do |record|
      if record.action == 'recommends'
        add_to_tree(record)
      else
        update_tree(record)
      end
    end
  end

  def add_to_tree(record)
    reward_tree.add(id: record.invitee, inviter: record.inviter)
  end

  def update_tree(record)
    reward_tree.accept(record.invitee)
  end

  def reward_tree
    @reward_tree ||= RewardTree.new
  end
end
