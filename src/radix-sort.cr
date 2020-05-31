# TODO: Write documentation for `Radix::Sort`
module Radix::Sort
  VERSION     = "0.1.0"
  RS_MAX_BITS =  8
  R           = 16
  K           = 0xffff + 1
  MASK        = 0xffff

  abstract class RSable(T)
    def get_key : UInt64
    end
  end

  def insertion_sort!(numbers : Array(RSable))
    up_to = numbers.size - 1
    (1..up_to).each do |i|
      if numbers[i].get_key < numbers[i - 1].get_key
        tmp = numbers[i]
        j = i
        while (j > 0 && tmp.get_key < numbers[j - 1].get_key)
          numbers[j] = numbers[j - 1]
          j -= 1
        end
        numbers[j] = tmp
      end
    end
  end

  def radix_sort!(items : Array(RSable))
    max_key = items.max_by { |x| x.get_key }.get_key
    num_buckets = 10
    buckets = Array(UInt32).new(10, 0)
    positions = Array(UInt32).new(10, 0)

    exp = 1
    while max_key // exp > 0
      # Do a pass of countsort
      buckets.fill(0)
      positions.fill(0)

      # Find how many item's keys are in each bucket for this digit
      items.each do |item|
        index = (item.get_key // exp) % 10
        buckets[index] += 1
      end

      # Find the number of elements less than or equal to i at each position
      (1...num_buckets).each do |i|
        buckets[i] += buckets[i - 1]
      end

      # copy buckets into positions so that buckets can be modfied
      buckets.each_with_index do |count, i|
        positions[i] = count
      end

      i = 0
      while i < items.size
        key = (items[i].get_key // exp) % 10
        placed = (key == 0 || (positions[key - 1] <= i && i < positions[key]))
        if placed
          i += 1
        else
          tmp = items[i]
          items[i] = items[buckets[key] - 1]
          items[buckets[key] - 1] = tmp
          buckets[key] -= 1
        end
      end
      exp *= 10
    end
  end
end
