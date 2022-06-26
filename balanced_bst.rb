class TreeNode
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

class QNode
  attr_accessor :data, :next

  def initialize(node)
    @data = node
    @next = nil
  end
end

class Queue
  attr_accessor :head, :tail, :count

  def initialize
    @head, @tail = nil
    @count = 0
  end

  def size
    @count
  end

  def empty?
    @count.zero?
  end

  #  Add new node of queue
  def enqueue(treenode)
    #  Create a new queue node
    node = QNode.new(treenode)
    #  Add first element into queue OR
    #  Add node at the end using tail
    @head.nil? ? @head = node : @tail.next = node
    @count += 1
    @tail = node
  end

  #  Delete a element into queue
  def dequeue
    #  Leave if Empty Queue
    return if @head.nil?

    #  Visit next node
    @head = @head.next
    @count -= 1
    #  When deleting a last node of linked list
    @tail = nil if head.nil?
  end

  #  Get front node
  def peek
    return nil if @head.nil?

    @head.data
  end
end

class BinaryTree
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
    node = TreeNode.new(array[mid])
    node.left = build_tree(array, first, mid - 1)
    node.right = build_tree(array, mid + 1, last)
    node
  end

  def display(node = @root)
    return if node.nil?

    print "#{node.data} "
    display(node.left)
    display(node.right)
  end

  def find(data, root = @root)
    return root if root.nil? || root.data == data

    root.data < data ? find(data, root.right) : find(data, root.left)
  end

  def insert(data)
    @root = insert_rec(data)
  end

  def insert_rec(data, root = @root)
    return TreeNode.new(data) if root.nil?

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

  ###
  ##
  #   utiliser un array comme queue (quand même garder la classe ?)
  ##
  ###
  def level_order
    return if @root.nil?

    q = Queue.new
    node = @root
    loop do
      q.enqueue(node.left) unless node.left.nil?
      q.enqueue(node.right) unless node.right.nil?
      p "queue => [#{q.head.data.data} // #{q.tail.data.data}]"
      #  Display level node
      print(' ', node.data)
      #  Remove current node
      q.dequeue
      #  Get new head
      node = q.peek
      break node if q.empty? || node.nil?
    end
  end
end

tree = BinaryTree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
# tree = Tree.new([1, 2, 3, 4, 5, 6, 7])

p tree.display
puts
# tree.insert(98)
# puts
# p tree.display
# puts
tree.level_order
