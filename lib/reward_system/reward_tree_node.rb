# frozen_string_literal: true

# Represent a node in reward tree.
#   id => the identifier value of the node.
#   inviter => the one who invited this node.
#   accepted => true if accepted; false otherwise.
#   points => points gained by inviting others.
class RewardTreeNode
  attr_reader :id, :inviter
  attr_accessor :accepted, :points

  def initialize(id:, inviter: nil, accepted: false)
    @id = id
    @inviter = inviter
    @accepted = accepted
    @points = 0
  end
end
