module imm_buffer(
    input logic clk,
    input logic rst,
    input logic [31:0] sign_extended_imm,
    output logic [31:0] imm_buffer_out
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      imm_buffer_out <= 32'b0;
    end else begin
      imm_buffer_out <= sign_extended_imm;
    end
  end
endmodule
