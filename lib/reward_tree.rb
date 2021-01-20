class RewardTree
  attr_accessor :nodes

  def initialize
    @nodes = {}
  end

  def add(id:, inviter:, accepted:)
    return if nodes[id]

    inviter_node = nodes[inviter]
    unless inviter_node
      inviter_node = RewardTreeNode.new(id: inviter)
      nodes[inviter] = inviter_node
    end

    node = RewardTreeNode.new(
      id: id, 
      inviter: inviter_node, 
      accepted: accepted
    )
    nodes[id] = node
    update_points_to_inviters(node: node, level: 0) if accepted
  end

  def update(id:, accepted:)
    node = nodes[id]
    node.accepted = accepted
    update_points_to_inviters(node: node, level: 0) if accepted
  end

  def update_points_to_inviters(node:, level:)
    return unless node.accepted

    inviter = node.inviter
    inviter.points += 0.5 ** level

    update_points_to_inviters(node: inviter, level: level + 1)
  end
end
