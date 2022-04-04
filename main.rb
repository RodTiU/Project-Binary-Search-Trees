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
      if root == Node.new(value)
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

  def pretty_print(node = @root, prefix = "", is_left = true)
    return p nil if @root.data == nil
    pretty_print(node.right, "#{prefix}#{is_left ? "│   " : "    "}", false) if node.right
    puts "#{prefix}#{is_left ? "└── " : "┌── "}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? "    " : "│   "}", true) if node.left
  end
end

tr = Tree.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20])
# tr.insert(15)
# tr.insert(17)
# tr.insert(21)
# tr.insert(7)
# tr.insert(8)
# tr.insert(9)
# tr.delete(1)
# tr.insert(2)
tr.pretty_print
