# TODO: Write documentation for `Radix::Sort`
module Radix::Sort
  VERSION     = "0.1.0"
  RS_MAX_BITS =  8
  R           = 16
  K           = 0xffff + 1
  MASK        = 0xffff

  abstract class RSable(T)
    def get_key : T
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

  # Inplace count sort
  def count_sort!(numbers : Array(RSable)) : Nil
    num_buckets = numbers.max_by { |n| n.get_key }
    buckets = Array(RSable).new(num_buckets, 0)

    (0...numbers.size).each do |i|
      buckets[numbers[i].get_key] += 1
    end
    k = 0
    (0...num_buckets).each do |i|
      (0...buckets[i]).each do |j|
        numbers[k] = i
        k += 1
      end
    end
  end

  # 32 bit radix sort in two passes
  # tmp is of equal length and used for first padd
  def radix_sort!(nodes : Array(RSable), tmp : Array(RSable))
    max_key = nodes.max_by { |n| n.get_key }
    count = 0
    shift = 0
    radix_counts = Array(Int32).new(K, 0)
    from = nodes
    to = tmp
    while count < 32 / R
      radix_counts.fill(0) # fill with zeros
      from.each do |node|
        radix_counts[((node.get_key >> shift) & MASK)] += 1
      end
      # make counts cumlative
      (1...K).each do |i|
        radix_counts[i] += radix_counts[i - 1]
      end
      # change counts to offsets
      (0...K - 1).each do |i|
        radix_counts[K - 1 - i] = radix_counts[K - 2 - i]
      end
      radix_counts[0] = 0
      from.each do |node|
        radix = ((node.get_key >> shift) & MASK)
        to[radix_counts[radix]] = node
        radix_counts[radix] += 1
      end
      count += 1
      shift += R
      swap_tmp = from
      from = to
      to = swap_tmp
    end
  end
end
