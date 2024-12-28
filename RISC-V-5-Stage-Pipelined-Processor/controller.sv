module controller (
    input logic [6:0] opcode,
    input logic [2:0] func3,
    input logic [6:0] func7,
    output logic [3:0] aluop,
    output logic rf_en,
    output logic imm_en,
    output logic jump_en,
    output logic mem_read,
    output logic mem_write,
    output logic [1:0] wb_sel,
    output logic sel_A,
    output logic csr_rd,  // control signal to read from CSR register file
    output logic csr_wr,
    is_mret
);

  always_comb begin
    // Default control signals
    rf_en     = 1'b0;  // Disable register write-back by default
    imm_en    = 1'b0;  // Disable immediate generation by default
    mem_read  = 1'b0;  // Disable memory read by default
    mem_write = 1'b0;  // Disable memory write by default
    aluop     = 4'b0000;  // Default ALU operation
    wb_sel    = 2'b00;  // Default to ALU result for write-back
    csr_wr    = 1'b0;
    csr_rd    = 1'b0;
    is_mret   = 1'b0;
    sel_A     = 1'b0;
    jump_en   = 1'b0;

    case (opcode)
      7'b0110011: // R-type instructions
        begin
        rf_en  = 1'b1;  // Enable write-back for R-type instructions
        imm_en = 1'b0;  // Immediate generation not used
        unique case (func3)
          3'b000: begin
            unique case (func7)
              7'b0000000: aluop = 4'b0000;  // ADD
              7'b0100000: aluop = 4'b0001;  // SUB
              7'b0000001: aluop = 4'b1011;  //MUL
            endcase
          end
          3'b001: aluop = 4'b0010;  // SLL
          3'b010: aluop = 4'b0011;  // SLT
          3'b011: aluop = 4'b0100;  // SLTU
          3'b100: aluop = 4'b0101;  // XOR
          3'b101: begin
            unique case (func7)
              7'b0000000: aluop = 4'b0110;  // SRL
              7'b0100000: aluop = 4'b0111;  // SRA
            endcase
          end
          3'b110: aluop = 4'b1000;  // OR
          3'b111: aluop = 4'b1001;  // AND
        endcase
      end

      7'b0010011: // I-type instructions
        begin
        rf_en  = 1'b1;  // Enable write-back for I-type instructions
        imm_en = 1'b1;  // Enable immediate generation
        unique case (func3)
          3'b000: aluop = 4'b0000;  // ADDI
          3'b010: aluop = 4'b0011;  // SLTI
          3'b011: aluop = 4'b0100;  // SLTIU
          3'b100: aluop = 4'b0101;  // XORI
          3'b110: aluop = 4'b1000;  // ORI
          3'b111: aluop = 4'b1001;  // ANDI
          3'b001: begin
            unique case (func7)
              7'b0000000: aluop = 4'b0010;  // SLLI
            endcase
          end
          3'b101: begin
            unique case (func7)
              7'b0000000: aluop = 4'b0110;  // SRLI
              7'b0100000: aluop = 4'b0111;  // SRAI
            endcase
          end
        endcase
      end

      7'b0110111: // LUI instructions
        begin
        rf_en  = 1'b1;  // Enable write-back for LUI
        imm_en = 1'b1;  // Enable immediate generation
        aluop  = 4'b1100;
      end

      7'b0010111: // AUIPC instructions
        begin
        rf_en  = 1'b1;  // Enable write-back for AUIPC
        imm_en = 1'b1;  // Enable immediate generation
        aluop  = 4'b1101;
        sel_A  = 1'b1;
      end

      7'b0000011: begin  // Load instructions
        rf_en    = 1'b1;  // Enable write-back for load instructions
        imm_en   = 1'b1;  // Enable immediate generation
        mem_read = 1'b1;  // Enable memory read
        wb_sel   = 2'b01;  // Select data from memory for write-back
        aluop = 4'b0000;  // LB (Load Byte)
      end

      7'b0100011: begin  // Store instructions
        rf_en     = 1'b0;  // Disable write-back for store instructions
        imm_en    = 1'b1;  // Enable immediate generation
        mem_write = 1'b1;  // Enable memory write
        aluop     = 4'b0000;
      end

      7'b1100011: // B-type (branch instructions)
        begin
        rf_en  = 1'b0;
        imm_en = 1'b1;
        sel_A  = 1'b1;
        aluop  = 4'b0000;
      end

      7'b1101111: // JAL instruction
        begin
        rf_en   = 1'b1;
        imm_en  = 1'b1;
        wb_sel  = 2'b10;  // PC + 4
        sel_A   = 1'b1;  // Use PC as opr_a
        aluop   = 4'b0000;
        jump_en = 1'b1;
      end

      7'b1100111: // JALR instruction
        begin
        rf_en   = 1'b1;
        imm_en  = 1'b1;
        wb_sel  = 2'b10;  // PC + 4
        aluop   = 4'b0000;
        jump_en = 1'b1;
      end
      7'b1110011: // CSR
        begin
        wb_sel = 2'b11;
        case (func3)
          3'b000: begin
            is_mret = 1'b1;
          end
          3'b001: begin
            csr_wr = 1'b1;
          end
          3'b010: begin
            csr_rd = 1'b1;
          end
          default: begin
            csr_rd  = 1'b1;
            csr_wr  = 1'b0;
            is_mret = 1'b0;
          end
        endcase
      end
      default: rf_en = 1'b0;  // Disable register file if unsupported opcode
    endcase
  end

endmodule
