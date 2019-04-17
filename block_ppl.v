module block_ppl(input[7:0] data, input[7:0] biSignal, output reg[15:0] outReg);
    reg[7:0] reg0;
    reg[7:0] reg1;
    reg[7:0] reg2;
    reg[7:0] reg3;
    reg[7:0] reg4;
    reg[7:0] reg5;
    reg[7:0] reg6;

    //reg[15:0] outReg;

    always @ (data or biSignal)
    begin
        if(biSignal[0] == 1)
            reg0 = data;
        else
            reg0 = 0;

        if (biSignal[1] == 1)
            reg1 = data << 1;
        else
            reg1 = 0;

        if (biSignal[2] == 1)
            reg2 = data << 2;
        else
            reg2 = 0;

        if (biSignal[3] == 1)
            reg3 = data << 3;
        else
            reg3 = 0;

        if (biSignal[4] == 1)
            reg4 = data << 4;
        else
            reg4 = 0;

        if (biSignal[5] == 1)
            reg5 = data << 5;
        else
            reg5 = 0;

        if (biSignal[6] == 1)
            reg6 = data << 6;
        else
            reg6 = 0;

        outReg = reg0 + reg1 + reg2 + reg3 + reg4 + reg5 + reg6;
        $display("reg0, reg1, reg3, reg4, reg5, reg6: ", reg0, reg1, reg2, reg3, reg4, reg5, reg6);
        $display("out:", outReg);
        if (biSignal[7] == 1)
            outReg = ~outReg + 1;
    end

    //assign out_block4 = outReg;

endmodule
