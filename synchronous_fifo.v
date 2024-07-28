module synchronous_fifo #(parameter DEPTH = 8, DATA_WIDTH =8)(
    input clk,reset_n,
    input write_en, read_en,
    input [DATA_WIDTH-1:0] in,
    output reg [DATA_WIDTH-1:0] out,
    output full, empty
    //output wrap_around
    

     
);

    parameter ptr_width = $clog2(DEPTH);
    reg [ptr_width:0] write_ptr;
    reg [ptr_width:0] read_ptr;
    reg [DATA_WIDTH-1:0] fifo[0:DEPTH-1];
    //reg wrap_around;

    //Setting values to default whenever actice low reset arrives// Synchronous Reset
    always@(posedge clk) begin
        if(reset_n == 0) begin
            write_ptr<=0;
            read_ptr<=0;
            out<=0;
            //wrap_around<=0;
            end
        end

    //Writing Data to the FIFO
    always@(posedge clk) begin
        if(write_en & !full) begin  
            fifo[write_ptr] <= in;
            write_ptr <= write_ptr +1;
            end
        end 

    //Reading Data from the FIFO
    always@(posedge clk) begin
        if(read_en &!empty) begin
            out<= fifo[read_ptr]  ;
            read_ptr <= read_ptr +1;
            end
    end
    
    //@(posedge clk) wrap_around <= write_ptr[ptr_width] ^ read_ptr[ptr_width];
    //assign wrap_around = write_ptr[ptr_width] ^ read_ptr[ptr_width];

    //Condition for full
    assign full = (write_ptr[ptr_width] != read_ptr[ptr_width]) && (write_ptr[ptr_width -1:0] == read_ptr[ptr_width-1:0]);
    // COndition for empty
    assign empty = (write_ptr == read_ptr);


endmodule

    



        


    



