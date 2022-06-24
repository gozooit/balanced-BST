class Node
  attr_accessor :data, :left, :right

  include Comparable
  def initialize(data)
    @data = data
    @left, @right = nil
  end

  def <=>(other)
    data <=> other.data
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array.sort.uniq, 0, array.length - 1)
  end

  def build_tree(array, first, last)
    return nil if first > last

    mid = if (first + last).even?
            (first + last) / 2
          else
            ((first + last - 1) / 2) + 1
          end
    node = Node.new(array[mid])
    node.left = build_tree(array, first, mid - 1)
    node.right = build_tree(array, mid + 1, last)
    node
  end

  def print(node = @root)
    return if node.nil?

    puts node.data
    print(node.left)
    print(node.right)
  end

  def find(data, root = @root)
    return root if root.nil? || root.data == data

    root.data < data ? find(data, root.right) : find(data, root.left)
  end

  def insert(data)
    @root = insert_rec(data)
  end

  def insert_rec(data, root = @root)
    return Node.new(data) if root.nil?

    return root.data if root.data.nil?

    if data < root.data
      root.left = insert_rec(data, root.left)
    elsif data > root.data
      root.right = insert_rec(data, root.right)
    end
    root
  end
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
# tree = Tree.new([1, 2, 3, 4, 5, 6, 7])

p tree.print
