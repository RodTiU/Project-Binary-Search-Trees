class Node
  include Comparable
  attr_accessor :data, :left, :right

  def <=>(other)
    # [data, left, right] <=> [other.data, other.left, other.right]
    data <=> other.data
  end

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
end

class Tree
  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(array)
    return if array.empty?
    return Node.new(array[0]) if array.length <= 1

    mid = array.length / 2
    root = Node.new(array[mid])
    root.left = build_tree(array[0...mid])
    root.right = build_tree(array[mid + 1..-1])
    root
  end

  def insert(value, root = @root)
    return @root.data = nil if @root.data.nil?

    if value == root.data
      nil
    elsif value < root.data
      if root.left.nil?
        root.left = Node.new(value)
        return root
      end

      insert(value, root.left)
    elsif value > root.data
      if root.right.nil?
        root.right = Node.new(value)
        return root
      end

      insert(value, root.right)
    end
  end

  def delete(value, root = @root)
    return @root.data = nil if @root.left.nil? && @root.right.nil? && @root.data == value

    if root == Node.new(value) || root.left == Node.new(value) || root.right == Node.new(value)
      # case node to delete have leafs in right and left side
      if root == Node.new(value) ||
         (root.left == Node.new(value) && !root.left.left.nil? && !root.left.right.nil?) ||
         (root.right == Node.new(value) && !root.right.left.nil? && !root.right.right.nil?)
        root = root.left if root.left == Node.new(value)
        root = root.right if root.right == Node.new(value)
        actual_root = root
        if root.right.left.nil?
          actual_root.data = root.right.data
          root.right = nil
          return
        end
        root = root.right
        root = root.left until root.left.left.nil?
        actual_root.data = root.left.data
        root.left = root.left.right
        #other cases
      elsif root.left == Node.new(value)
        return root.left = nil if root.left.left.nil? && root.left.right.nil?
        return root.left = root.left.right if root.left.left.nil? && !root.left.right.nil?
        return root.left = root.left.left if !root.left.left.nil? && root.left.right.nil?
      elsif root.right == Node.new(value)
        return root.right = nil if root.right.left.nil? && root.right.right.nil?
        return root.right = root.right.right if root.right.left.nil? && !root.right.right.nil?
        return root.right = root.right.left if !root.right.left.nil? && root.right.right.nil?
      end
    elsif root.data > value
      return nil if root.left.nil? && root.right.nil?

      delete(value, root.left)
    elsif root.data < value
      return nil if root.left.nil? && root.right.nil?

      delete(value, root.right)
    end
  end

  def find(value, root = @root)
    if root.data == value
      return root
    elsif root.data < value
      find(value, root.right)
    elsif root.data > value
      find(value, root.left)
    end
  end

  def level_order(root = @root, queue = [], level_array = [])
    level_array << root.data
    queue << root.left unless root.left.nil?
    queue << root.right unless root.right.nil?
    return level_array if queue.empty?

    level_order(queue.shift, queue, level_array)
  end

  def inorder(root = @root, inorder_array = [])
    return inorder_array if root.nil?

    inorder(root.left, inorder_array)
    inorder_array << root.data
    inorder(root.right, inorder_array)
  end

  def preorder(root = @root, preorder_array = [])
    return preorder_array if root.nil?

    preorder_array << root.data
    preorder(root.left, preorder_array)
    preorder(root.right, preorder_array)
  end

  def postorder(root = @root, postorder_array = [])
    return postorder_array if root.nil?

    postorder(root.left, postorder_array)
    postorder(root.right, postorder_array)
    postorder_array << root.data
  end

  def height(root = @root, depth = [], count = 0)
    return depth if root.nil?

    # count = 0
    height(root.left, depth, count + 1)
    height(root.right, depth, count + 1)
    depth << count
    depth = depth.max
  end

  def depth(node_value, root = @root, count = 0)
    return 0 if node_value == @root.data
    return nil if root.nil?

    if node_value > root.data
      count += 1
      depth(node_value, root.right, count)
    elsif node_value < root.data
      count += 1
      depth(node_value, root.left, count)
    else
      count
    end
  end

  def balanced?(root = @root)
    return false if (height(root.left) - height(root.right)).abs > 1
    return true if (height(root.left) - height(root.right)).abs <= 1
  end

  def rebalance
    @root = build_tree(preorder().sort)
  end

  def pretty_print(node = @root, prefix = "", is_left = true)
    return p nil if @root.data.nil?

    pretty_print(node.right, "#{prefix}#{is_left ? "???   " : "    "}", false) if node.right
    puts "#{prefix}#{is_left ? "????????? " : "????????? "}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? "    " : "???   "}", true) if node.left
  end
end
