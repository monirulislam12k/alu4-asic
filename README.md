# 4-Bit ALU. RTL to GDSII ASIC Design

A educational ASIC design journey: from Verilog RTL implementation and functional verification to Sky130A physical design, GDSII generation and 2.5D layout visualization.

<p align="center">

<img src="docs/images/alu4_layout.png" alt="4-bit ALU layout" width="700">

</p>

<p align="center">

<b>Verilog • Verilator • Yosys • ABC • LibreLane • Sky130A • KLayout</b>

</p>

---

## Overview

This project. Takes a 4-bit Arithmetic Logic Unit (ALU) through an RTL-to-GDSII ASIC design flow using open-source tools.

The ALU supports eight logical operations selected through a 3-bit control signal. The design was simulated, synthesized, formally checked and physically implemented using the SkyWater 130 open-source PDK.

**Project status:** Physical design flow completed. GDSII generated. Antenna, LVS and DRC checks passed in the reported run.

> **Note:** This is an ASIC design completed using an open-source PDK and toolchain. It has not been fabricated as a silicon chip. Is not presented as production signoff.

## ALU Architecture

The design has two 4-bit operands, one 3-bit operation selector, a 4-bit result and a zero flag.

<p align="center">

<img src="docs/images/alu4_architecture.png" alt="4-bit ALU architecture diagram" width="800">

</p>

### Supported Operations

sel` Operation | Description |

|:---:|---|---|

| `000` | ADD | A + B |

001` | SUB | A. B |

| `010` |. | Bitwise. |

| `011` | Bitwise OR |

| `100` | XOR | Bitwise XOR |

| `101` | NOT | Bitwise NOT of A |

| `110` | LEFT SHIFT | A shifted left by one bit |

111` | RIGHT SHIFT | A shifted right by one bit |

The `zero` output is asserted when the 4-bit ALU result is `0000`.

### Module Interface

| Signal | Direction | Width | Description |

|---|---|---:|---|

| `A` | Input 4-bit | First operand |

| `B` | Input 4-bit | Second operand |

sel` | Input | 3-bit | Operation selector |

| `result` | Output | 4-bit | ALU result |

| `zero` | Output | 1-bit | Zero-result indicator |

## RTL Implementation

The design is written in Verilog using a always @(*)` block and a `case` statement.

```verilog

module alu4 (

input wire [3:0] A,

input wire [3:0] B,

input wire [2:0] sel

output reg [3:0] result

output wire zero

);

always @(*) begin

case (sel)

3'b000: result = A + B;

3'b001: result = A. B;

3'b010: result = A & B;

3'b011: result = A | B;

3'b100: result = A ^ B;

3'b101: result = ~A;

3'b110: result = A << 1;

3'b111: result = A >> 1;

default: result = 4'b0000;

endcase

end

assign zero = (result == 4'b0000);

endmodule

```

## Design Flow

<p align="center">

<img src="docs/images/alu4_design_flow.png" alt="RTL to GDSII design flow" width="850">

</p>

The project followed this sequence:

1. **RTL Design**. Implemented the 4-bit ALU in Verilog.

2. **Functional Simulation**. Used Verilator to verify the design behavior.

3. **Logic Synthesis**. Used Yosys to translate RTL into a synthesized logic representation.

4. **Technology Mapping**. Used ABC through the synthesis flow for logic optimization.

5. **Formal Equivalence**. Checked equivalence between the reference and synthesized designs.

6. **Physical Design**. Used LibreLane with the Sky130A PDK.

7. **GDSII Generation**. Generated the layout database.

8. **Layout Inspection**.. Inspected the layout in KLayout including a 2.5D visualization.

## Gate-Level Logic

The following visualization represents the synthesized gate-level logic.

<p align="center">

<img src="docs/images/alu4_gate_level.png" alt="4-bit ALU gate-level logic" width="850">

</p>

### Generic Synthesis Results

The Yosys/ABC generic gate inventory contained 105 logic cells.

| Generic cell type | Count |

|---|---:|

| ANDNOT | 34 |

|. | 4 |

| MUX | 7 |

| NAND | 6 |

|. | 6 |

| NOT 8 |

ORNOT | 3 |

| OR | 24 |

| XNOR | 7 |

| XOR | 6 |

| **Total** | **105** |

> These are logic-cell counts from synthesis, not Sky130 standard-cell counts and not transistor counts.

## Physical Design Results

The physical implementation was completed using:

- **Flow:** LibreLane v3.0.17

- **Technology:** SkyWater SKY130A

- **Layout viewer:** KLayout

- ** database:** GDSII

### Verification Summary

| Check | Result |

|---|---|

| LibreLane flow | Completed (80/80 steps) |

| Antenna check | Passed |

| LVS | Passed |

| DRC | Passed |

| LVS device comparison | 75 devices on each side |

LVS net comparison | 84 nets on each side |

The reported LVS run found a matching layout and netlist.

**Important verification notes:**

- Some technology-specific checks were skipped by the flow.

- The run reported floating-net warnings.

- Timing constraints used a virtual-clock fallback because the ALU is combinational and has no real clock port.

- Timing results should therefore not be interpreted as timing signoff.

- The design has not undergone silicon fabrication or silicon-level validation.

## Physical Layout & 2.5D Visualization

### Full Layout

<p align="center">

<img src="docs/images/alu4_layout.png" 4-bit ALU layout" width="850">

</p>

### 2.5D Layout View

<p align="center">

<img src="docs/images/alu4_2p5d.png" alt="4-bit ALU 2.5D layout visualization" width="850">

</p>

The 2.5D view helps visualize the physical metal layers and their interconnections in the generated layout. It is a visualization of the design database, not a photograph of a fabricated chip.

## Tools & Technologies

Tool / Technology | Purpose |

|---|---|

| Verilog | RTL design |

| Verilator | Functional simulation |

| Yosys Logic synthesis |

| ABC | Logic optimization and mapping |

| Formal equivalence checking | RTL-to-netlist equivalence verification |

| LibreLane | RTL-to-GDSII physical design flow |

| Sky130A | source 130nm PDK |

| KLayout | GDSII inspection and layout visualization |

| Graphviz Logic graph visualization |

| Ubuntu on WSL | Linux development environment |

## Repository Structure

```text

alu4-asic/

├── src/                  # Verilog RTL

├── simulation/           # Simulation testbench

├── synthesis/            # Synthesis outputs and logic graph

├── physical_design/

│   ├── gds/               # GDSII layout files

│   ├── lef/               # Library Exchange Format

│   ├── def/               # Design Exchange Format

│   ├── netlist/           # Physical-design netlist

│   ├── spice/             # SPICE netlist

│   └── reports/           # Physical-design reports

├── docs/

│   └── images/            # Project diagrams and screenshots

├── config.json

├── LICENSE

└── README.md

```

## Running the Project

The following commands illustrate the RTL simulation and synthesis steps. They assume the required tools are installed and the commands are run from the repository root.

### 1. Clone the repository

```bash

git clone https://github.com/monirulislam12k/alu4-asic.git

cd alu4-asic

```

### 2. Run Verilator lint

```bash

verilator --lint- -Wall src/alu4.v

```

### 3. Run Yosys synthesis

```bash

yosys -p "read_verilog src/alu4.v; hierarchy -top alu4; proc; opt; techmap; opt; stat"

```

### 4. Physical Design

The physical-design configuration is provided in `config.json`. To reproduce the GDSII flow, install and configure the LibreLane version and Sky130A PDK then run the design using the LibreLane interface appropriate to your installation.

The checked-in GDSII and reports are outputs, from the completed run, not a guarantee that every environment will reproduce results.

## Key Learning Outcomes

Through this project I gained experience with:

- Writing combinational Verilog RTL.

- Designing an ALU with operations.

- Functional simulation and debugging.

- Understanding synthesis and generic gate-level logic.

- Formal equivalence checking.

- Exploring the RTL-to-GDSII ASIC design process.

- Working with an open-source PDK.

- Inspecting GDSII layouts and physical metal layers in KLayout.

- Understanding the difference between RTL, synthesized logic and physical layout.

## Future Improvements

- Expand the ALU to 8-bit or 16-bit.

- Add status flags such as carry, overflow and sign.

- Improve the verification environment with test cases.

- Explore timing constraints and timing analysis with a properly constrained design.

- Compare synthesis and physical implementation results across configurations.

## Author

**Md. Monirul Islam Payel**

Diploma in Electronics Engineering

Rajshahi Polytechnic Institute, Bangladesh

Interested in Semiconductor Engineering, VLSI RTL Design and ASIC Physical Design.

- GitHub: [@monirulislam12k](https://github.com/monirulislam12k)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

<p align="center">

<b>Learning by building. Exploring silicon, one design, at a time.</b>

</p>
