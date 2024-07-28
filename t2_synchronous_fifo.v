
`include "synchronous_fifo.v"
module t2_synchronous_fifo;
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 8;
    
    reg clk, reset_n;
    reg write_en, read_en;
    reg [DATA_WIDTH-1:0] in;
    wire [DATA_WIDTH-1:0] out;
    wire full, empty;

    // Instantiate the FIFO
    synchronous_fifo #(DEPTH, DATA_WIDTH) uut (
        .clk(clk),
        .reset_n(reset_n),
        .write_en(write_en),
        .read_en(read_en),
        .in(in),
        .out(out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        write_en = 0;
        read_en = 0;
        in = 0;

        // Apply reset
        reset_fifo();
        
        // Test case 1: Write data into the FIFO until it is full
        write_fifo();
        
        // Test case 2: Read data from the FIFO until it is empty
        read_fifo();
        
        // Test case 3: Simultaneous read and write operations
        simultaneous_read_write();

        $finish;
    end

    task reset_fifo;
        begin
            reset_n = 0;
            #10;
            reset_n = 1;
            #10;
        end
    endtask

    task write_fifo;
        integer i;
        begin
            $display("Writing data to FIFO");
            for (i = 0; i < DEPTH; i = i + 1) begin
                @(posedge clk);
                write_en = 1;
                in = $random % 256;
                #10;
                write_en = 0;
                #10;
            end
            $display("FIFO full condition: %b", full);
        end
    endtask

    task read_fifo;
        integer i;
        begin
            $display("Reading data from FIFO");
            for (i = 0; i < DEPTH; i = i + 1) begin
                @(posedge clk);
                read_en = 1;
                #10;
                read_en = 0;
                #10;
            end
            $display("FIFO empty condition: %b", empty);
        end
    endtask

    task simultaneous_read_write;
        integer i;
        begin
            $display("Simultaneous read and write operations");
            for (i = 0; i < DEPTH; i = i + 1) begin
                @(posedge clk);
                write_en = 1;
                read_en = 1;
                in = $random % 256;
                #10;
                write_en = 0;
                read_en = 0;
                #10;
            end
            $display("Final FIFO full condition: %b", full);
            $display("Final FIFO empty condition: %b", empty);
        end
    endtask

    initial begin
        $dumpfile("sync_fifo_TB.vcd");
        $dumpvars(0, t2_synchronous_fifo);
    end
endmodule
