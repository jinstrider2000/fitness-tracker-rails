module FitnessTracker::SortableActivity

  def valid_filter_options
    self::VALID_FILTER_OPTIONS
  end

  def valid_order_options
    self::VALID_ORDER_OPTIONS
  end

  def valid_filter?(filter)
    valid_filter_options.any? {|valid_filter| valid_filter.downcase == filter.try(:downcase)}
  end

end