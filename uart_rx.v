module uart_rx #(
    parameter CLK_FREQ  = 100_000_000,
    parameter BAUD_RATE = 9600
)(
    input  wire clk,
    input  wire rst,
    input  wire rx,
    output reg  [7:0] rx_data,
    output reg  rx_done
);

    localparam integer BAUD_CNT = CLK_FREQ / BAUD_RATE;

    reg [13:0] baud_cnt;
    reg [3:0]  bit_cnt;
    reg [7:0]  shift_reg;
    reg        rx_busy;

    always @(posedge clk) begin
        if (rst) begin
            rx_busy <= 0;
            rx_done <= 0;
            baud_cnt <= 0;
            bit_cnt <= 0;
        end
        else begin
            rx_done <= 0;

            /* Detect start bit */
            if (!rx_busy && rx == 0) begin
                rx_busy  <= 1;
                baud_cnt <= BAUD_CNT/2; // sample center
                bit_cnt  <= 0;
            end
            else if (rx_busy) begin
                if (baud_cnt == BAUD_CNT-1) begin
                    baud_cnt <= 0;

                    if (bit_cnt < 8) begin
                        shift_reg[bit_cnt] <= rx;
                        bit_cnt <= bit_cnt + 1;
                    end
                    else begin
                        rx_busy <= 0;
                        rx_data <= shift_reg;
                        rx_done <= 1;
                    end
                end
                else
                    baud_cnt <= baud_cnt + 1;
            end
        end
    end
endmodule
