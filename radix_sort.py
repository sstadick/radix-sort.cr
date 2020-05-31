"""Counting sort with a generic get keys function in place"""
from dataclasses import dataclass
from typing import List


@dataclass
class Interval:
    start: int
    stop: int

    def get_key(self) -> int:
        return self.start


def count_sort(items: List[Interval]) -> None:
    """In place countsort on items that have a key function.
    Source: https://ita.skanev.com/08/problems/02.html
    """
    # Create a zero'd out list of buckets to hold up to the max number in `nums`
    num_buckets: int = max(items, key=lambda item: item.get_key()).get_key()
    buckets: List[int] = [0 for _ in range(num_buckets + 1)]
    positions: List[int] = [0 for _ in range(num_buckets + 1)]

    # Find how many item's keys are in each bucket
    for item in items:
        buckets[item.get_key()] += 1

    # Find the number of elements less than or equal to i at each position
    for i in range(1, num_buckets + 1):
        buckets[i] += buckets[i - 1]

    # copy buckets into positions so that buckets can be modified
    for i, count in enumerate(buckets):
        positions[i] = count

    i: int = 0
    while i < len(items):
        # Looking to place `items[i]`
        key = items[i].get_key()

        # Is this item already in the correct place? ie, for this key,
        # there are already the correct number of elements (i) below it,
        # and we haven't passed it's maximum index yet
        placed: bool = (positions[key - 1] <= i and i < positions[key])
        if placed:
            i += 1
        else:
            # put items[i] at the highest index spot indicated by buckets
            # put what was at the at spot into items[i], then decrement the
            # number at buckets[key] since we've now used that index
            tmp = items[i]
            items[i] = items[buckets[key] - 1]
            items[buckets[key] - 1] = tmp
            buckets[key] -= 1


def radix_sort(items: List[Interval]) -> None:
    max_key: int = max(items, key=lambda x: x.get_key()).get_key()
    num_buckets = 10  # since we are in base 10
    buckets = [0 for _ in range(num_buckets + 1)]  # zero'd out buckets
    positions = [0 for _ in range(num_buckets + 1)]  # zero'd out positions

    exp = 1
    while max_key / exp > 0:
        # Do a pass of countsort

        # Re-zero the reused buckets
        for i in range(num_buckets):
            buckets[i] = 0
            positions[i] = 0

        # Find how many item's keys are in each bucket for this digit
        for item in items:
            index = (item.get_key() // exp) % 10
            buckets[index] += 1

        # Find the number of elements less than or equal to i at each position
        for i in range(1, num_buckets + 1):
            buckets[i] += buckets[i - 1]

        # copy buckets into positions so that buckets can be modified
        for i, count in enumerate(buckets):
            positions[i] = count

        # Same routine as count_sort
        i = 0
        while i < len(items):
            key = (items[i].get_key() // exp) % 10
            placed = (key == 0 or (positions[key - 1] <= i and i < positions[key]))
            if placed:
                i += 1
            else:
                tmp = items[i]
                items[i] = items[buckets[key] - 1]
                items[buckets[key] - 1] = tmp
                buckets[key] -= 1
        # Move to next digit
        exp *= 10


def main() -> None:
    items: List[Interval] = [
        Interval(50, 100),
        Interval(50, 60),
        Interval(20, 70),
        Interval(80, 200),
        Interval(1, 4),
    ]
    print(f"pre sort: {items=}")
    count_sort(items)
    print(f"post sort: {items=}")

    items2: List[Interval] = [
        Interval(50, 100),
        Interval(50, 60),
        Interval(20, 70),
        Interval(80, 200),
        Interval(1, 4),
    ]
    print(f"pre sort: {items2=}")
    radix_sort(items2)
    print(f"post sort: {items2=}")


if __name__ == '__main__':
    main()
