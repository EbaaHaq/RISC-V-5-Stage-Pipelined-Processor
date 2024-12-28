module rs2_buffer(
    input logic clk,
    input logic rst,
    input logic [31:0] rdata2,
    output logic [31:0] rdata2_buffer_out
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      rdata2_buffer_out <= 32'b0;
    end else begin
      rdata2_buffer_out <= rdata2;
    end
  end
endmodule
