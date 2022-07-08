# Class for node in the binary tree
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

# Class about the queue
class Queue
  attr_accessor :current, :discovered, :count

  def initialize
    @current = []
    @discovered = []
    @count = 0
  end

  def discovered_data
    @discovered.map(&:data)
  end

  def head
    @current.first
  end

  def tail
    @current.last
  end

  def size
    @count
  end

  def empty?
    @count.zero?
  end

  def queued?(node)
    @current.include?(node) || @discovered.include?(node)
  end

  #  Add new node of queue
  def enqueue(node)
    return if queued?(node)

    @current.push(node)
    # p "queue #{@current.map(&:data)}"
    @count += 1
  end

  # reverse enqueue
  def renqueue(node)
    return if queued?(node)

    @current.unshift(node)
    # p "queue #{@current.map(&:data)}"
    @count += 1
  end

  #  Delete a element into queue
  def dequeue
    #  Leave if Empty Queue
    return if @current.empty?

    # p "dequeued node #{head.data}"
    @discovered.push(@current.shift)
    @count -= 1
  end
end

# Class about the binary tree
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

  #  Explore Tree by level order traversal method
  def levelorder
    return if @root.nil?

    q = Queue.new
    node = @root
    levelorder_array = []
    loop do
      q.enqueue(node.left) unless node.left.nil?
      q.enqueue(node.right) unless node.right.nil?
      #  Yield current node if block given, else push node.data into array
      block_given? ? yield(node) : levelorder_array.push(node.data)
      node = q.head
      break if q.empty? || node.nil?

      q.dequeue
    end
    return levelorder_array unless block_given?
  end

  def inorder
    return if @root.nil?

    q = Queue.new
    node = @root
    inorder_array = []
    loop do
      # unless node.right.nil?
      loop do
        q.renqueue(node)
        node.left.nil? || q.queued?(node.left) ? break : node = node.left
      end

      loop do
        q.empty? ? break : node = q.head
        block_given? ? yield(node) : inorder_array.push(node.data)
        q.dequeue

        next if node.right.nil? || q.queued?(node.right)

        node = node.right
        q.renqueue(node)
        break
      end
      break if q.empty? || node.nil?
    end
    inorder_array unless block_given?
  end

  # Ne fonctionne pas parce qu'il reprend le left alors qu'il est déjà traité
  # def inorder
  #   return if @root.nil?

  #   q = Queue.new
  #   node = @root
  #   inorder_array = []
  #   loop do
  #   #   unless q.discovered.include?(node)

  #     p '-------- left'
  #     # until node.left.nil? || q.discovered.include?(node.left)
  #     #   p "node = #{node.data} #{q.discovered.include?(node.left) unless node.left.nil?}"
  #     #   # p '----- enqueue left'
  #     #   q.renqueue(node)
  #     #   node = node.left
  #     # end
  #     loop do
  #       q.renqueue(node)
  #       node.left.nil? || q.discovered.include?(node.left) ? break : node = node.left
  #     end

  #     loop do
  #       p "-------- yield #{node.data}"
  #       block_given? ? yield(node) : inorder_array.push(node.data)
  #       # p "queue = #{q.current.map {|i| i.data}.to_s}"
  #       node = q.head unless q.empty?
  #       q.dequeue
  #       p "discovered #{q.discovered_data(&:data)}"
  #       break if node.right.nil? || q.empty?
  #     end

  #     p '--------  right'

  #     # p "discovered = #{q.discovered.map {|i| i.data}.to_s}"
  #     # p "node = #{node.data} #{q.discovered.include?(node.right) unless node.right.nil?}"
  #     unless node.right.nil? || q.discovered.include?(node.right)
  #       # p '----- enqueue right'
  #       q.renqueue(node.right)
  #       node = node.right
  #     end
  #     # p "queue = #{q.current.map {|i| i.data}.to_s}"
  #     break if q.empty? || node.nil?
  #   end
  #   inorder_array unless block_given?
  # end
end

tree = BinaryTree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
# tree = Tree.new([1, 2, 3, 4, 5, 6, 7])

p tree.levelorder
puts
# tree.insert(98)
# puts
# p tree.display
# puts
tree.inorder { |i| p i.data unless i.nil?}
