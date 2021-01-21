# frozen_string_literal: true

describe RewardTreeNode do
  subject(:node) do
    described_class.new(id: 'B', inviter: 'A', accepted: false)
  end

  it { expect(node.id).to eq 'B' }
  it { expect(node.inviter).to eq 'A' }
  it { expect(node.accepted).to eq false }
  it { expect(node.points).to eq 0 }
end
