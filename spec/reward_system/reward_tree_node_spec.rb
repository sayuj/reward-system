# frozen_string_literal: true

describe RewardTreeNode do
  it 'returns a node' do
    node = RewardTreeNode.new(id: 'B', inviter: 'A', accepted: false)
    expect(node.id).to eq 'B'
    expect(node.inviter).to eq 'A'
    expect(node.accepted).to eq false
    expect(node.points).to eq 0
  end
end
