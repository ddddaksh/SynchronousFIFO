`include "synchronous_fifo.v"

module t_synchronous_fifo;

    parameter DATA_WIDTH = 8;
    parameter DEPTH = 8;
    wire [DATA_WIDTH-1:0] data_out;
    wire full;
    wire empty;

    reg clk, rst_n;
    reg w_en, r_en;
    reg [DATA_WIDTH-1:0] data_in;

    reg [DATA_WIDTH-1:0] wdata_q[0:DEPTH-1];
    integer i,j;

    // Instantiate the FIFO
    synchronous_fifo #(.DEPTH(DEPTH), .DATA_WIDTH(DATA_WIDTH)) s_fifo(
        .clk(clk), 
        .reset_n(rst_n), 
        .write_en(w_en), 
        .read_en(r_en), 
        .in(data_in), 
        .out(data_out), 
        .full(full), 
        .empty(empty)
    );

    // Clock generation
    initial begin 
        clk = 0; 
        forever #5 clk = ~clk; 
    end

    // Write operations
    initial begin
        rst_n = 0;
        w_en = 0;
        data_in = 0;
        #15 rst_n = 1;  // Release reset after some time

        for (i = 0; i < DEPTH; i++) begin
            @(posedge clk);
            w_en = 1;
            data_in = i + 1;  // Writing sequential data
            wdata_q[i] = data_in;  // Store data for later comparison
        end
        w_en = 0;  // Stop writing after filling the FIFO
    end

    // Read operations and comparison
    initial begin
        r_en = 0;
        #100;  // Wait for write operations to complete

        for (i = 0; i < DEPTH; i++) begin
            @(posedge clk);
            r_en = 1;
            #1;
            if (data_out != wdata_q[i])
                $error("Time = %0t: Comparison Failed: expected data = %h, read data = %h", $time, wdata_q[i], data_out);
            else
                $display("Time = %0t: Comparison Passed: expected data = %h, read data = %h", $time, wdata_q[i], data_out);
        end
        r_en = 0;  // Stop reading after emptying the FIFO

        #50;  // Wait some time before finishing the simulation
        $finish;
    end

    // Dump waveform data
    initial begin
        $dumpfile("t_synchronous_fifo2.vcd");
        $dumpvars(0, t_synchronous_fifo);
    end

endmodule
