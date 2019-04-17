module testbench_pipe;
    reg[7:0] data;
    reg[7:0] biSignal;
    wire [15:0] outputData;
    reg clk;

    initial
    begin
        clk = 1;
        data = 8'd3;
        biSignal[7] = 0;
        forever
        begin
            #60 biSignal[6:0] <= 8'd64;
            #100 biSignal[6:0] <= 8'd83;
            #140  biSignal[6:0] <= 8'd89;
            #180  biSignal[6:0] <= 8'd75;
            #220 biSignal[6:0] <= 8'd50;
            #260 biSignal[6:0] <= 8'd36;
        end
    end

    always #20 clk <= ~clk;//半周期为20ns,全周期为40ns的一个信号

    block_ppl bq(data, biSignal, outputData);

endmodule // testbench
