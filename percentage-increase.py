#!/usr/bin/env python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title percentage increase
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon %
# @raycast.argument1 { "type": "text", "placeholder": "start" }
# @raycast.argument2 { "type": "text", "placeholder": "finish" }

# Documentation:
# @raycast.description Calculate the percentage increase from start to end value
# @raycast.author @johnsyweb
# @raycast.authorURL https://raycast.com/johnsyweb

import sys
from decimal import Decimal, getcontext

getcontext().prec = 10

def calculate_percentage_increase(start, end):
    """
    Calculate the percentage increase from start to end value.
    Args:
      start (float or Decimal): The starting value. Must not be zero.
      end (float or Decimal): The ending value.
    Returns:
      str: The formatted percentage increase with 2 decimal places, followed by '%'.
         Returns "Cannot calculate (division by zero)" if start is zero.
    Example:
      >>> calculate_percentage_increase(100, 150)
      '50.00%'
      >>> calculate_percentage_increase(200, 150)
      '-25.00%'
      >>> calculate_percentage_increase(0, 100)
      'Cannot calculate (division by zero)'
    """
    if start == 0:
        return "Cannot calculate (division by zero)"

    percentage_increase = ((end - start) / abs(start)) * Decimal('100')

    return f"{percentage_increase:.2f}%"

if len(sys.argv) != 3:
    print(f"Expected start and end values, got {" ".join(sys.argv[1:])}")
    sys.exit(1)

try:
    start_value, end_value = map(Decimal, sys.argv[1:3])
    print(calculate_percentage_increase(start_value, end_value))
except Exception as e:  # pylint: disable=broad-except
    print(f"Error: {e}")
