module ir_buffer_execute (
    input logic clk,
    input logic rst,
    input logic [31:0] data,
    output logic [31:0] instruction
);

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      instruction <= 32'b0;
    end else begin
      instruction <= data;
    end
  end
endmodule
