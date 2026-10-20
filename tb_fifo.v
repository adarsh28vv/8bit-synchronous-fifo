`timescale 1ns/1ps

module tb_fifo;
    reg clk = 1'b0;
    reg rst = 1'b1;
    reg wr_en = 1'b0;
    reg rd_en = 1'b0;
    reg [7:0] din = 8'h00;
    wire [7:0] dout;
    wire full;
    wire empty;

    fifo dut (
        .clk(clk), .rst(rst), .wr_en(wr_en), .rd_en(rd_en),
        .din(din), .dout(dout), .full(full), .empty(empty)
    );

    always #5 clk = ~clk;

    task write_byte(input [7:0] value);
        begin
            @(negedge clk);
            wr_en = 1'b1;
            rd_en = 1'b0;
            din = value;
            @(negedge clk);
            wr_en = 1'b0;
        end
    endtask

    task read_expect(input [7:0] expected);
        begin
            @(negedge clk);
            rd_en = 1'b1;
            wr_en = 1'b0;
            @(posedge clk);
            #1;
            if (dout !== expected) begin
                $display("FAIL: expected %02h, got %02h at time %0t", expected, dout, $time);
                $fatal(1);
            end
            @(negedge clk);
            rd_en = 1'b0;
        end
    endtask

    integer i;
    initial begin
        // Reset and check initial status.
        repeat (2) @(negedge clk);
        rst = 1'b0;
        #1;
        if (empty !== 1'b1 || full !== 1'b0) begin
            $display("FAIL: incorrect flags after reset");
            $fatal(1);
        end

        // Fill all 8 locations and verify full flag.
        for (i = 0; i < 8; i = i + 1)
            write_byte(8'hA0 + i);
        #1;
        if (full !== 1'b1 || empty !== 1'b0) begin
            $display("FAIL: FIFO should be full");
            $fatal(1);
        end

        // Drain in FIFO order and verify data.
        for (i = 0; i < 8; i = i + 1)
            read_expect(8'hA0 + i);
        #1;
        if (empty !== 1'b1 || full !== 1'b0) begin
            $display("FAIL: FIFO should be empty");
            $fatal(1);
        end

        // Check pointer wrap-around with another write/read sequence.
        write_byte(8'h12);
        write_byte(8'h34);
        read_expect(8'h12);
        read_expect(8'h34);

        $display("PASS: FIFO basic functionality tests completed successfully.");
        $finish;
    end
endmodule
