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
