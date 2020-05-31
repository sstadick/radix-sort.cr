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
        placed: bool = (key == 0 or (positions[key - 1] <= i and i < positions[key]))
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


def main() -> None:
    items: List[Interval] = [
        Interval(5, 10),
        Interval(5, 6),
        Interval(2, 7),
        Interval(8, 20),
        Interval(1, 4),
    ]
    print(f"pre sort: {items=}")
    count_sort(items)
    print(f"post sort: {items=}")


if __name__ == '__main__':
    main()
