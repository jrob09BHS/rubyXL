module RubyXL

  class BorderEdge < OOXMLObject
    define_attribute(:style,   :string)
    define_child_node(RubyXL::Color, :default => 'none', :values => 
                        %w{ none thin medium dashed dotted thick double hair
                            mediumDashed dashDot mediumDashDot dashDotDot slantDashDot } )

    def ==(other)
      style == other.style
    end
  end

  # http://www.schemacentral.com/sc/ooxml/e-ssml_border-2.html
  class Border < OOXMLObject
    define_attribute(:diagonalUp,   :bool)
    define_attribute(:diagonalDown, :bool)
    define_attribute(:outline,      :bool, :default => true)
    define_child_node(RubyXL::BorderEdge, :node_name => :left)
    define_child_node(RubyXL::BorderEdge, :node_name => :right)
    define_child_node(RubyXL::BorderEdge, :node_name => :top)
    define_child_node(RubyXL::BorderEdge, :node_name => :bottom)
    define_child_node(RubyXL::BorderEdge, :node_name => :diagonal)
    define_child_node(RubyXL::BorderEdge, :node_name => :vertical)
    define_child_node(RubyXL::BorderEdge, :node_name => :horizontal)
    define_element_name 'border'
    set_countable

    def get_edge_style(direction)
      edge = self.send(direction)
      edge && edge.style
    end

    def set_edge_style(direction, style)
      self.send("#{direction}=", RubyXL::BorderEdge.new(:style => style))
    end

    def ==(other)
      (diagonal_up == other.diagonal_up) &&
        (diagonal_down == other.diagonal_down) &&
        (outline == other.outline) &&
        (left == other.left) &&
        (right == other.right) &&
        (top == other.top) &&
        (bottom == other.bottom) &&
        (diagonal == other.diagonal) &&
        (vertical == other.vertical) &&
        (horizontal == other.horizontal)
    end

  end

end
