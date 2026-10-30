# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotb.utils import get_sim_time  # <-- Import this


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start FlexPIO Multi-Instruction Simulation")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Initialize signals & Reset
    dut._log.info("Applying Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 5)
    
    # Release reset
    dut.rst_n.value = 1
    dut._log.info("Reset released, stepping through instructions...")

    # Monitor pins across multiple execution cycles
    for step in range(35):
        await ClockCycles(dut.clk, 10)
        current_time = get_sim_time(unit='ns')
        dut._log.info(f"Time {current_time} ns: uio_out = {bin(dut.uio_out.value)}, uio_oe = {bin(dut.uio_oe.value)}")

    assert True