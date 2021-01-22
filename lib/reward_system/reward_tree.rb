# frozen_string_literal: true

# Represents the invitations in a tree structure.
# Each customer is represented as nodes and
# each node keeps a track of its inviter, and
# the points gained by inviting new customers.
class RewardTree
  attr_accessor :nodes

  def initialize
    @nodes = {}
  end

  # Add a new node into the tree.
  # -> It skips if the node is already present in the tree.
  # -> It creates a new node and append to the tree.
  # -> It updates points to the inviters.
  def add(id:, inviter:)
    # Skip this if the node is already present in the tree.
    return if nodes[id]

    inviter_node = find_or_create_node(inviter)
    node = RewardTreeNode.new(
      id: id,
      inviter: inviter_node.id,
      accepted: false
    )
    nodes[id] = node
    update_points_to_inviters(node: node, level: 0)
  end

  # Updates an existing node in the tree to accepted state.
  # -> It raises error if it is trying to update a non-existing node.
  # -> It skips if the node is already accepted.
  # -> It update the node to accepted state.
  # -> It updates points to the inviters
  def accept(id)
    node = nodes[id]

    # Raise error if trying to update a non-existing node.
    raise RewardSystemError, "#{id} has no invitation to accept" unless node

    # Skip this if already accepted.
    return if node.accepted

    node.accepted = true
    update_points_to_inviters(node: node, level: 0)
  end

  # Updates points to the invites.
  # -> It skips if not accepted.
  # -> It finds inviters recursively and update points.
  #
  # The inviter gets (1/2)^k points for each confirmed invitation,
  # where k is the level of the invitation:
  # level 0 (people directly invited) yields 1 point,
  # level 1 (people invited by someone invited by the original customer)
  #   gives 1/2 points,
  # level 2 invitations (people invited by someone on level 1)
  #   awards 1/4 points
  # and so on.
  def update_points_to_inviters(node:, level:)
    # Skip this if it is not accepted.
    return unless node.accepted

    # Skip this if there is no inviter.
    return unless node.inviter

    inviter = nodes[node.inviter]
    inviter.points += 0.5**level

    update_points_to_inviters(node: inviter, level: level + 1)
  end

  private

  # Find or create node.
  # -> It finds node by id from the nodes in the tree.
  # -> If there is not node present, then it creates a
  #    node and insert into the tree.
  # -> It clears the inviter if not accepted.
  # -> It returns the node.
  def find_or_create_node(id)
    inviter_node = nodes[id]
    unless inviter_node
      inviter_node = RewardTreeNode.new(id: id)
      nodes[id] = inviter_node
    end
    inviter_node.inviter = nil unless inviter_node.accepted
    inviter_node
  end
end
