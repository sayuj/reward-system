# frozen_string_literal: true

require 'spec_helper'

describe RewardTree do
  subject(:tree) { described_class.new }

  describe '.add' do
    it 'adds a node to the tree' do
      tree.add(id: 'B', inviter: 'A')
      expect(tree.nodes.keys).to eq %w[A B]
    end
  end

  describe '.update' do
    it 'updates a node in the tree' do
      tree.add(id: 'B', inviter: 'A')
      tree.accept('B')
      expect(tree.nodes['B'].accepted).to eq true
    end
  end

  describe 'point calculation' do
    context 'with level 0 inviter only' do
      before do
        tree.add(id: 'B', inviter: 'A')
        tree.accept('B')
      end

      it 'add points to inviter for level 0 inviter' do
        expect(tree.nodes['A'].points).to eq 1
      end
    end

    context 'with level 0 - 1 inviters' do
      before do
        tree.add(id: 'B', inviter: 'A')
        tree.accept('B')
        tree.add(id: 'C', inviter: 'B')
        tree.accept('C')
      end

      it 'add points to inviter for level 0 - 1 inviters' do
        expect(tree.nodes['A'].points).to eq 1.5
      end
    end

    context 'with level 0 - 2 inviters' do
      before do
        tree.add(id: 'B', inviter: 'A')
        tree.accept('B')
        tree.add(id: 'C', inviter: 'B')
        tree.accept('C')
        tree.add(id: 'D', inviter: 'C')
        tree.accept('D')
        tree.add(id: 'E', inviter: 'C')
      end

      it 'add points to inviter for level 0 - 2 inviters' do
        expect(tree.nodes['A'].points).to eq 1.75
      end
    end
  end
end
