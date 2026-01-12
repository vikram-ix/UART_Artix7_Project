module uart_tb;

    reg clk = 0;
    reg rst = 1;
    reg rx  = 1;

    wire [7:0] rx_data;
    wire rx_done;

    always #5 clk = ~clk;

    uart_rx dut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    task send_byte;
        input [7:0] data;
        integer i;
        begin
            rx = 0; #104160;
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i]; #104160;
            end
            rx = 1; #104160;
        end
    endtask

    initial begin
        #50 rst = 0;
        send_byte(8'h55);
        #200000;
        $stop;
    end
endmodule
