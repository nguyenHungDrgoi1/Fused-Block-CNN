"""
Quantization utilities for fixed-point (DFP) quantization.
"""

import numpy as np
from typing import Tuple

def to_twos_complement(val: int, total_bits: int) -> str:
    """
    Convert an integer value to its two's complement binary string representation.

    Args:
        val (int): The integer value to convert (signed).
        total_bits (int): The total number of bits in the representation.

    Returns:
        str: Binary string of length total_bits.
    """
    if val < 0:
        val = (1 << total_bits) + val
    return format(val & ((1 << total_bits) - 1), f'0{total_bits}b')


def dfp_quantize(
    x: np.ndarray,
    int_bits: int,
    total_bits: int
) -> Tuple[np.ndarray, int]:
    """
    Quantize a floating-point numpy array to fixed-point representation (signed).

    Args:
        x (np.ndarray): Input floating-point array.
        int_bits (int): Number of integer bits (including sign).
        total_bits (int): Total bits for fixed-point representation.

    Returns:
        Tuple[np.ndarray, int]:
            q (np.ndarray): Quantized integer numpy array (dtype=np.int8).
            frac_bits (int): Number of fractional bits used.
    """
    frac_bits = total_bits - int_bits
    scale     = 1 << frac_bits
    x_int     = np.round(x * scale).astype(np.int32)
    max_val   = (1 << (total_bits - 1)) - 1
    min_val   = - (1 << (total_bits - 1))
    q         = np.clip(x_int, min_val, max_val).astype(np.int8)
    return q, frac_bits
