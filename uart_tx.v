module uart_tx #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 9600
)(
    input  wire clk,
    input  wire rst,
    input  wire tx_start,
    input  wire [7:0] tx_data,
    output reg  tx,
    output reg  tx_busy
);

    localparam integer BAUD_CNT = CLK_FREQ / BAUD_RATE;

    reg [13:0] baud_cnt;
    reg [3:0]  bit_cnt;
    reg [9:0]  shift_reg;

    always @(posedge clk) begin
        if (rst) begin
            tx <= 1'b1;
            tx_busy <= 1'b0;
            baud_cnt <= 0;
            bit_cnt <= 0;
        end
        else begin
            if (tx_start && !tx_busy) begin
                shift_reg <= {1'b1, tx_data, 1'b0}; // stop, data, start
                tx_busy   <= 1'b1;
                baud_cnt  <= 0;
                bit_cnt   <= 0;
            end
            else if (tx_busy) begin
                if (baud_cnt == BAUD_CNT-1) begin
                    baud_cnt <= 0;
                    tx <= shift_reg[bit_cnt];
                    bit_cnt <= bit_cnt + 1;

                    if (bit_cnt == 9) begin
                        tx_busy <= 1'b0;
                        tx <= 1'b1;
                    end
                end
                else
                    baud_cnt <= baud_cnt + 1;
            end
        end
    end
endmodule
