# =====================================================================
# FlexPIO Comprehensive End-to-End Test Program
# Exercises: Single-pin toggles, multi-pin masks, upper/lower nibbles, 
#            precise wait intervals, and rapid state transitions.
# =====================================================================

# --- Phase 1: Single Pin Basic Toggle (Pin 0) ---
SET 0b00000001 1    # Turn Pin 0 HIGH
WAIT 10             # Hold HIGH for 10 cycles
SET 0b00000001 0    # Turn Pin 0 LOW
WAIT 10             # Hold LOW for 10 cycles

# --- Phase 2: Multi-Pin Simultaneous Activation (Pins 0, 1, 2) ---
SET 0b00000111 1    # Drive Pins 0, 1, and 2 HIGH simultaneously
WAIT 25             # Hold for 25 cycles
SET 0b00000111 0    # Clear Pins 0, 1, and 2
WAIT 15             # Quiet gap

# --- Phase 3: Upper Nibble / High-Pin Mask Test (Pins 4, 5, 6, 7) ---
SET 0b11110000 1    # Drive upper nibble HIGH
WAIT 50             # Long delay (50 cycles) to test extended wait timer counts
SET 0b11110000 0    # Clear upper nibble
WAIT 20             # Quiet gap

# --- Phase 4: Rapid State Transitions (Protocol Handshake Style) ---
SET 0b01010101 1    # Set even pins high (0, 2, 4, 6)
WAIT 5              # Short pulse
SET 0b10101010 1    # Set odd pins high (1, 3, 5, 7)
WAIT 5              # Short pulse

# --- Phase 5: Clean Exit / Idle State ---
SET 0b11111111 0    # Ensure all pins are driven LOW
WAIT 100            # Final idle window before test wrap-up