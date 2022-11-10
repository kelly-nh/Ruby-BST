# Name: Kelly Ngoc Hoang

class Node
    attr_accessor :value, :left, :right

    # A tree node includes a value and two nil children
    def initialize(value)
        @value = value
        @left = nil
        @right = nil
    end
end

class BST
    include Comparable
    attr_accessor :root, :height

    def initialize(&compare_method)
        @root = nil
        @height = 0
        @compare = Proc.new{ |first, second| first <=> second };
        @compare = compare_method unless compare_method.nil?
    end

    #########
    # Add a new item to the binary tree. Add must maintain a valid binary search tree structure as new data is added to the tree.
    # Duplicate items should be stored in the right subtree.
    #########
    def add(item)
        # tree has no root
        if @root.nil?
            @root = Node.new(item)

        # tree has been already developed
        else
            curr_node = @root
            prev_node = @root

            # find the position of new item
            while !curr_node.nil?
                # prev_node decides the parent for new child node
                prev_node = curr_node

                if @compare.call(curr_node.value, item) > 0   # if item < curr_node.value
                    curr_node = curr_node.left
                else
                    curr_node = curr_node.right
                end
            end

            # create a new node for the item and add to the tree
            # the new node is the child of prev_node     
            if @compare.call(prev_node.value, item) > 0      # if item < prev_node.value
                prev_node.left = Node.new(item)
            else
                # child >= parent: go to the right
                prev_node.right = Node.new(item)
            end
        end
        @height += 1
    end

    #########
    # returns true if the tree is empty. Otherwise returns false.
    #########
    def empty?
        if @root.nil?
            return true
        else
            return false
        end
    end

    #########
    # returns true if the item is found in the tree, otherwise returns false.
    #########
    def include?(item)       
        if self.empty?
            # tree does not have any nodes
            return false
        else
            # use Helper to find where is item
            includeHelper(item, @root)
        end 
    end

    def includeHelper(item, current)
        # current node is nil
        if current.nil?
            return false
        # current node matches item: found!
        elsif @compare.call(current.value, item) == 0      # elsif item == current.value
            return true
        # item < current node: go to the left
        elsif @compare.call(current.value, item) > 0       # elsif item < current.value
            return includeHelper(item, current.left)
        # item > current node: go to the right
        else
            return includeHelper(item, current.right)
        end

    end

    #########
    # returns the number of items in the tree.
    #########
    def size
        return @height
    end

    #########
    # performs an in-order traversal of the tree, passing each item found to block.
    # in-order traversal: left-root-right
    #########
    def each_inorder(&block)
        @my_block = block unless block.nil?;
        inorderTraversal(@root, &block)
    end

    def inorderTraversal(current, &block)
        # current node is nil
        return if current.nil?
       
        # print left node recursively
        inorderTraversal(current.left, &block)
       
        # print root
        @my_block.call(current.value)
        # yield(current.value)
       
        # print right node recursively
        inorderTraversal(current.right, &block)
    end

    #########
    # performs an in-order traversal of the tree, passing each item found to block. 
    # The values returned by block are collected into a new BST, which is returned by collect_inorder.
    #########
    def collect_inorder(&block)
        # dup BST
        @my_block = block unless block.nil?;
        dup_tree = BST.new

        # change nodes value based on block body
        modify_node_inorder(@root, dup_tree, &block)

        # return the tree
        dup_tree
    end

    def modify_node_inorder(current, tree, &block)
        # current node is nil
        return if current.nil?

        # move to left node recursively  
        modify_node_inorder(current.left, tree, &block)
        
        # call the current node value
        # modify the current node value according to the given block body
        # add it to the new tree
        tree.add(@my_block.call(current.value))

        # move to right node recursively
        modify_node_inorder(current.right, tree, &block)
    end 

    #########
    # returns a sorted array of all the elements in the BST
    #########
    def to_a
        # new array
        sorted = []

        # inorder traversal copy each node value to the array
        copy_inorder(@root, sorted)
        
        # return the array
        sorted

    end

    def copy_inorder(current, array)
        # current node is nil
        return if current.nil?
       
        # move to left node recursively  
        copy_inorder(current.left, array)
       
        # add to array
        array << current.value
       
        # move to right node recursively
        copy_inorder(current.right, array)
    end

    #########
    # returns a new binary search tree with the same contents as the original tree
    #########
    def dup
        # new tree
        dup_tree = BST.new

        # inorder traversal copy each node value to the new tree
        dup_inorder(@root, dup_tree)

        # return new tree
        dup_tree
    end


    def dup_inorder(current, tree)
        # current node is nil
        return if current.nil?
       
        # move to left node recursively  
        dup_inorder(current.left, tree)
       
        # add to array
        tree.add(current.value)
       
        # move to right node recursively
        dup_inorder(current.right, tree)
    end
end


##%#%#% Uncomment section below to test the BST functions
#-------- Test ------ tree1 -------#
# tree1 = BST.new
# print("tree1 empty --> ", tree1.empty?, "\n")
# tree1.add(15)
# tree1.add(2)
# tree1.add(33)
# tree1.add(26)
# print("added: '15..2..33..26'", "\n")
# print("tree1 empty --> ", tree1.empty?, "\n")
# print("tree1 size --> ", tree1.size, "\n")
# print("(26) in tree1 --> ", tree1.include?(26), "\n")
# print("tree1 array --> ", tree1.to_a, "\n")
# tree1dup = tree1.dup
# print("tree1dup array --> ", tree1dup.to_a, "\n\n")

# print("print each inorder --> ")
# tree1.each_inorder {|x| print x, "  "}
# print("\n\n")

# #-------- Test ------ tree2 -------#
# tree2 = BST.new{|first, second| first <=> second}
# print("tree2 empty --> ", tree2.empty?, "\n")
# tree2.add(8)
# tree2.add(4)
# tree2.add(10)
# print("added: '8..4..10'", "\n")
# print("tree2 empty --> ", tree2.empty?, "\n")
# print("tree2 size --> ", tree2.size, "\n")
# print("(2) in tree2 --> ", tree2.include?(2), "\n")
# print("tree2 array --> ", tree2.to_a, "\n")

# tree2sqr = tree2.collect_inorder{|x| x**2}
# print("tree2^2 array --> ", tree2sqr.to_a, "\n\n")

# print("print each inorder --> ")
# tree2.each_inorder {|x| print x, "  "}