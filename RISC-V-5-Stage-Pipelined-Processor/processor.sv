module processor (
    input logic clk,
    input logic rst
);
  // Internal signals
  logic [31:0] pc_out;
  logic [31:0] inst;
  logic [ 6:0] opcode;
  logic [31:0] csr_rdata;
  logic [31:0] read_data_from_data_memory;  // Data read from data memory
  logic [31:0] write_data;  // Data to write to data memory
  logic [ 2:0] func3;
  logic [ 6:0] func7;
  logic [ 4:0] rs1;
  logic [ 4:0] rs2;
  logic [ 4:0] rd;
  logic [31:0] alu_result;  // ALU output
  logic [31:0] rdata1;
  logic [31:0] rdata2;
  logic [31:0] opr_b;
  logic [31:0] opr_a;
  logic [31:0] wdata;
  logic [ 3:0] aluop;
  logic [31:0] sign_extended_imm;
  logic rf_en, imm_en, mem_read, mem_write, csr_rd, csr_wr, jump_en, sel_A;
  logic [ 1:0] wb_sel;  // Write-back select signal from controller
  logic        br_true;
  logic [31:0] next_pc;  // Next PC value for JAL, JALR, and branches
  logic trap, is_mret, epc_taken;
  logic [31:0] epc;
  logic [31:0] pc_fetch, pc_decode, pc_execute, pc_mem;
  logic [31:0] ir_buffer_fetch_out;  // Fetch-to-Decode buffer
  logic [31:0] ir_buffer_decode_out;  // Decode-to-Execute buffer
  logic [31:0] ir_buffer_execute_out;  // Execute-to-Memory buffer
  logic [31:0] ir_buffer_mem_out;  // Memory-to-WriteBack buffer
  logic [31:0] imm_buffer_out;
  logic [31:0] rdata1_buffer_out, rdata2_buffer_out, wd_buffer_out;
  logic [31:0] alu_buffer_execute_out, alu_buffer_mem_out, rd_buffer_out;
  logic [3:0] aluopE;
  logic
      rf_enE,
      rf_enM,
      rf_enW,
      imm_enE,
      jump_enE,
      mem_readE,
      mem_readM,
      mem_writeE,
      mem_writeM,
      sel_AE;
  logic [1:0] wb_selE, wb_selM, wb_selW;

  // Program Counter instance
  pc pc_inst (
      .clk   (clk),
      .rst   (rst),
      .pc_in (next_pc),
      .pc_out(pc_out)
  );

  pc_buffer_fetch pc_buffer_fetch_inst (
      .clk   (clk),
      .rst   (rst),
      .pc_in (pc_out),
      .pc_out(pc_fetch)
  );

  pc_buffer_decode pc_buffer_decode_inst (
      .clk   (clk),
      .rst   (rst),
      .pc_in (pc_fetch),
      .pc_out(pc_decode)
  );

  pc_buffer_execute pc_buffer_execute_inst (
      .clk   (clk),
      .rst   (rst),
      .pc_in (pc_decode),
      .pc_out(pc_execute)
  );

  pc_buffer_mem pc_buffer_mem_inst (
      .clk   (clk),
      .rst   (rst),
      .pc_in (pc_execute),
      .pc_out(pc_mem)
  );

  // Instruction Memory Instance
  inst_mem imem (
      .addr(pc_out),
      .data(inst)
  );

  ir_buffer_fetch ir_buffer_fetch_inst (
      .clk        (clk),
      .rst        (rst),
      .data       (inst),                // Data from instruction memory
      .instruction(ir_buffer_fetch_out)  // Output to decode stage
  );

  ir_buffer_decode ir_buffer_decode_inst (
      .clk   (clk),
      .rst   (rst),
      .data  (ir_buffer_fetch_out), // Data from fetch stage
      .instruction  (ir_buffer_decode_out) // Output to execute stage
  );

  // Execute Stage IR Buffer
  ir_buffer_execute ir_buffer_execute_inst (
      .clk   (clk),
      .rst   (rst),
      .data  (ir_buffer_decode_out), // Data from decode stage
      .instruction  (ir_buffer_execute_out) // Output to memory stage
  );

  // Memory Stage IR Buffer
  ir_buffer_mem ir_buffer_mem_inst (
      .clk        (clk),
      .rst        (rst),
      .data       (ir_buffer_execute_out),  // Data from execute stage
      .instruction(ir_buffer_mem_out)       // Output to write-back stage
  );

  // Instruction Decoder
  inst_dec inst_instance (
      .inst             (inst),
      .ir_buffer_mem_out(ir_buffer_mem_out),
      .rs1              (rs1),
      .rs2              (rs2),
      .rd               (rd),
      .opcode           (opcode),
      .func3            (func3),
      .func7            (func7)
  );

  // Register File
  reg_file reg_file_inst (
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .rf_en(rf_enW),
      .clk(clk),
      .rdata1(rdata1),
      .rdata2(rdata2),
      .wdata(wdata)
  );

  rs1_buffer rs1_buffer_inst (
      .clk(clk),
      .rst(rst),
      .rdata1(rdata1),
      .rdata1_buffer_out(rdata1_buffer_out)
  );

  rs2_buffer rs2_buffer_inst (
      .clk(clk),
      .rst(rst),
      .rdata2(rdata2),
      .rdata2_buffer_out(rdata2_buffer_out)
  );

  csr csr_inst (
      .csr_rd(csr_rd),
      .csr_wr(csr_wr),
      .inst(inst),
      .pc(next_pc),
      .rdata(csr_rdata),
      .wdata(write_data),
      .rst(rst),
      .clk(clk),
      .is_mret(is_mret),
      .epc(epc),
      .epc_taken(epc_taken)
  );

  // Controller
  controller contr_inst (
      .opcode(opcode),
      .func3(func3),
      .func7(func7),
      .rf_en(rf_en),
      .csr_rd(csr_rd),
      .csr_wr(csr_wr),
      .aluop(aluop),
      .imm_en(imm_en),
      .mem_read(mem_read),
      .mem_write(mem_write),
      .sel_A(sel_A),
      .jump_en(jump_en),
      .wb_sel(wb_sel)  // Write-back select signal
  );

  controller_buffer_decode controller_buffer_decode_inst (
      .clk       (clk),
      .rst       (rst),
      .aluop     (aluop),
      .rf_en     (rf_en),
      .imm_en    (imm_en),
      .jump_en   (jump_en),
      .mem_read  (mem_read),
      .mem_write (mem_write),
      .wb_sel    (wb_sel),
      .sel_A     (sel_A),
      .aluopE    (aluopE),
      .rf_enE    (rf_enE),
      .imm_enE   (imm_enE),
      .jump_enE  (jump_enE),
      .mem_readE (mem_readE),
      .mem_writeE(mem_writeE),
      .wb_selE   (wb_selE),
      .sel_AE    (sel_AE)
  );

  controller_buffer_execute controller_buffer_execute_inst (
      .clk       (clk),
      .rst       (rst),
      .rf_enE    (rf_enE),
      .mem_readE (mem_readE),
      .mem_writeE(mem_writeE),
      .wb_selE   (wb_selE),
      .rf_enM    (rf_enM),
      .mem_readM (mem_readM),
      .mem_writeM(mem_writeM),
      .wb_selM   (wb_selM)
  );

  controller_buffer_mem controller_buffer_mem_inst (
      .clk    (clk),
      .rst    (rst),
      .rf_enM (rf_enM),
      .wb_selM(wb_selM),
      .rf_enW (rf_enW),
      .wb_selW(wb_selW)
  );

  // ALU Multiplexer
  alu_mux alu_mux_inst (
      .sign_extended_imm(imm_buffer_out),
      .imm_en(imm_enE),
      .rdata2(rdata2_buffer_out),
      .opr_b(opr_b)
  );

  opr_A_mux opr_A_mux_inst (
      .rdata1(rdata1_buffer_out),
      .pc_out(pc_decode),
      .sel_A (sel_AE),
      .opr_a (opr_a)
  );

  // ALU
  alu alu_inst (
      .opr_a  (opr_a),
      .opr_b  (opr_b),
      .aluop  (aluopE),
      .opr_res(alu_result)  // ALU result
  );

  alu_buffer_execute alu_buffer_execute_inst (
      .clk(clk),
      .rst(rst),
      .opr_res(alu_result),
      .alu_buffer_execute_out(alu_buffer_execute_out)
  );

  alu_buffer_mem alu_buffer_mem_inst (
      .clk(clk),
      .rst(rst),
      .alu_buffer_execute_out(alu_buffer_execute_out),
      .alu_buffer_mem_out(alu_buffer_mem_out)
  );

  // Immediate Generator
  imm_gen imm_gen_inst (
      .inst(inst),
      .sign_extended_imm(sign_extended_imm),
      .func3(func3),
      .opcode(opcode)
  );

  imm_buffer imm_buffer_inst (
      .clk(clk),
      .rst(rst),
      .sign_extended_imm(sign_extended_imm),
      .imm_buffer_out(imm_buffer_out)
  );

  // Data Memory Instance
  data_mem data_mem_inst (
      .clk       (clk),                        // Clock signal for memory
      .addr      (alu_buffer_execute_out),     // Address for load/store (from ALU result)
      .write_data(wd_buffer_out),              // Data to write to memory (from rdata2)
      .mem_read  (mem_readM),                  // Memory read enable
      .mem_write (mem_writeM),                 // Memory write enable
      .func3     (func3),
      .rdata     (read_data_from_data_memory)  // Data read from memory
  );

  // Branch Condition Generator
  branch_cond_gen branch_cond_gen_inst (
      .func3  (func3),
      .rdata1 (rdata1_buffer_out),
      .rdata2 (rdata2_buffer_out),
      .br_true(br_true)
  );

  wd_buffer wd_buffer_inst (
      .clk(clk),
      .rst(rst),
      .rdata2_buffer_out(rdata2_buffer_out),
      .wd_buffer_out(wd_buffer_out)
  );

  rd_buffer rd_buffer_inst (
      .clk(clk),
      .rst(rst),
      .rdata(read_data_from_data_memory),
      .rd_buffer_out(rd_buffer_out)
  );

  writeback_mux writeback_mux_inst (
      .read_data_from_data_memory(rd_buffer_out),
      .alu_result(alu_buffer_mem_out),
      .csr_rdata(csr_rdata),
      .wb_sel(wb_selW),
      .pc(pc_mem),
      .wdata(wdata)
  );

  pc_mux pc_mux_inst (
      .pc_out(pc_out),
      .alu_result(alu_buffer_execute_out),
      .br_true(br_true),
      .jump_en(jump_enE),
      .epc_taken(epc_taken),
      .epc(epc),
      .next_pc(next_pc)
  );

endmodule
