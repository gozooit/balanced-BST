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
    array.sort!.uniq!
    @root = build_tree(array, 0, array.length - 1)
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

  def delete(data, root = @root)
    # Bad case
    return root if root.nil?

    p root.data
    # If the key to be deleted
    # is smaller than the root's
    # key then it lies in left subtree
    if data < root.data
      root.left = delete(data, root.left)
    # If the kye to be delete
    # is greater than the root's key
    # then it lies in right subtree
    elsif data > root.data
      root.right = delete(data, root.right)
    # If key is same as root's key, then this is the node
    # to be deleted
    else
      # Node with only one child or no child
      if root.left.nil?
        tmp = root.right
        root = nil
        return tmp
      elsif root.right.nil?
        tmp = root.left
        root = nil
        return tmp
      end
      # Node with two children:
      # Get the inorder successor
      # (smallest in the right subtree)
      tmp = find_min_value
      # Copy the inorder successor's
      # content to this node
      root.data = tmp.data
      # Delete the inorder successor
      root.right = delete(tmp.key, root.right)
    end
    root
  end

  def find_min_value(root = @root)
    current = root
    current = current.left until current.left.nil?
    current
  end
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
# tree = Tree.new([1, 2, 3, 4, 5, 6, 7])

p tree.print
puts
# tree.insert(98)
# puts
# p tree.print
# puts
tree.delete(1)
puts
p tree.print
