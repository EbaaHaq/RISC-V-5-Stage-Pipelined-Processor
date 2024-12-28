module wd_buffer(
    input logic clk,
    input logic rst,
    input logic [31:0] rdata2_buffer_out,
    output logic [31:0] wd_buffer_out
);

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      wd_buffer_out <= 32'b0;
    end else begin
      wd_buffer_out <= rdata2_buffer_out;
    end
  end
endmodule
