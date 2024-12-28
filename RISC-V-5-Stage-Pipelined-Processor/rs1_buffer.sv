module rs1_buffer(
    input logic clk,
    input logic rst,
    input logic [31:0] rdata1,
    output logic [31:0] rdata1_buffer_out
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      rdata1_buffer_out <= 32'b0;
    end else begin
      rdata1_buffer_out <= rdata1;
    end
  end
endmodule
