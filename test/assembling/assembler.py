#!/usr/bin/env python3
import sys

def assemble(assembly_code):
    machine_code = []
    for line in assembly_code.splitlines():
        line = line.split('#')[0].strip() # Remove comments
        if not line:
            continue
        
        parts = line.split()
        mnemonic = parts[0].upper()
        
        if mnemonic == "SET":
            # Syntax: SET pin_mask val (e.g., SET 0b00000001 1 or SET 0x01 1)
            mask = int(parts[1], 0) & 0xFF
            val = int(parts[2], 0) & 1
            # Opcode 000 (3 bits), unused (1 bit), mask (8 bits), val (1 bit), unused (3 bits) = 16 bits
            instr = (0b000 << 13) | (mask << 4) | (val << 3)
            machine_code.append(f"{instr:04X}")
            
        elif mnemonic == "WAIT":
            # Syntax: WAIT cycles (e.g., WAIT 10)
            cycles = int(parts[1], 0) & 0x3FF # 10-bit count
            # Opcode 001 (3 bits), unused (3 bits), cycles (10 bits) = 16 bits
            instr = (0b001 << 13) | (cycles & 0x3FF)
            machine_code.append(f"{instr:04X}")
            
        else:
            raise ValueError(f"Unknown instruction: {mnemonic}")
            
    return machine_code

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python assemble.py <input.asm> <output.hex>")
        sys.exit(1)
        
    with open(sys.argv[1], "r") as f:
        code = f.read()
        
    hex_lines = assemble(code)
    
    with open(sys.argv[2], "w") as f:
        f.write("\n".join(hex_lines) + "\n")
    print(f"Successfully compiled {sys.argv[1]} -> {sys.argv[2]} ({len(hex_lines)} instructions)")