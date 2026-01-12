module top_uart (
    input  wire clk,
    input  wire rst,
    input  wire rx,
    input  wire btn,
    output wire tx,
    output wire [7:0] led
);

    wire [7:0] rx_data;
    wire rx_done;

    uart_rx uart_rx_inst (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    uart_tx uart_tx_inst (
        .clk(clk),
        .rst(rst),
        .tx_start(rx_done),
        .tx_data(rx_data),
        .tx(tx),
        .tx_busy()
    );

    assign led = rx_data;

endmodule
