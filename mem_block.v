module mem(data_write, enable, clk, reset, mode, data_read, outmode, readenable);
    input wire signed[15:0] data_write;
    input enable;
    input clk;
    input reset;
    input mode;
    output reg signed [15:0] data_read;
    output reg outmode;
    output reg readenable;
    reg signed [15:0] memory1[0:63];
    reg signed [15:0] memory2[0:63];
    reg modeSave;
    //reg tmpmode;
    reg changeflag;
    reg readflag;
    reg incond0;
    reg incond1;
    reg incond2;
    reg incond3;
    reg incond4;
    reg block00rStart;
    reg block01rStart;
    reg block10rStart;
    reg block11rStart;
    reg symbol;
    reg tmpmode;
    reg readenabletmp;


    reg[1:0] block4_locate;

    reg mem1flag;//1->8, 0->4
    reg mem2flag;
    //reg block4_wtran2;
    reg origin;
    integer i, j, k1, k2, row, col,counter;
    reg flag;

    always @ (posedge clk or negedge reset)
    begin
        if(reset == 0)
        begin
            //mem1flag = 1'b0;
            block00rStart <= 0;
            block01rStart <= 0;
            block10rStart <= 0;
            block11rStart <= 0;
            symbol <= 0;
            readflag <= 0;
            incond0 <= 1;
            incond1 <= 1;
            incond2 <= 1;
            incond3 <= 1;
            mem1flag <= 0;
            mem2flag <= 0;
            block4_locate <= 2'b00;
            //tmpmode = mode;
            changeflag <= 0;
            readenabletmp <= 0;
            counter = 0;
            flag <= 0;
            row <= 0;
            col <= 0;
            origin <= 0;
            i <= 0;
            j <= 0;

        end
        else

        begin
        if(enable == 1)
        begin

            if(origin == 0)
            begin
                tmpmode <= mode;
                origin <= 1;
            end

            if(mode == 1)
            begin
                //$display("mode = 1");
                if(flag == 0)
                begin
                    if(incond4)
                    begin
                        i <=0;
                        col <=0;
                        incond4 <= 0;
                    end
                    mem1flag <= 1;
                    memory1[i*8 + col] <= data_write;
                    i <= i + 1;
                    if (i == 7)
                    begin
                        i <= 0;
                        col <= col + 1;
                        if (col == 7)
                        begin
                            col <= 0;
                            flag <= 1;
                            modeSave <= mode;
                            incond4 <= 1;
                            if(symbol == 0)
                            begin
                                readenabletmp <= 1;
                                readflag <= 0;
                                symbol <= 1;
                            end
                        end

                    end
                    /*if((i == 1) && (col == 6)&&(symbol == 0))
                    begin
                        readenabletmp <= 1;
                        readflag <= 0;
                        symbol <= 1;
                    end*/

                end

                else
                begin
                    if(incond4)
                    begin
                        i <=0;
                        col <=0;
                        incond4 <= 0;
                    end
                    mem2flag <= 1;
                    memory2[i*8 + col] <= data_write;
                    i <= i + 1;
                    if (i == 7)
                    begin
                        i <= 0;
                        col <= col + 1;
                        if (col == 7)
                        begin
                            col <= 0;
                            flag <= 0;
                            modeSave <= mode;
                            incond4 <= 1;
                            if(symbol == 0)
                            begin
                                readenabletmp <= 1;
                                readflag <= 0;
                                symbol <= 1;
                            end
                        end
                    end
                    /*if((i == 1) && (col == 6)&&(symbol == 0))
                    begin
                        readenabletmp <= 1;
                        readflag <= 0;
                        symbol <= 1;
                    end*/


                end
            end
            else//4x4
            begin
                //$display("mode = 0");
                if(flag == 0)
                begin
                    if(block4_locate == 2'b00)
                    begin
                        //$display("block4:00");
                        //$display("i, col: ", i, col);
                        if(incond0)
                        begin
                            i <=0;
                            col <=0;
                            incond0 <= 0;
                        end
                        mem1flag <= 0;
                        memory1[i*8 + col] <= data_write;
                        //$display("write_data: ", data_write);
                        i <= i + 1;
                        if (i == 3)
                        begin
                            i <= 0;
                            col <= col + 1;
                            if (col == 3)
                            begin
                                //if(changeflag == 1)
                                flag <= 0;
                                col <= 4;
                                i <= 0;
                                modeSave <= mode;
                                incond0 <= 1;
                                block4_locate <= 2'b01;
                            end
                        end

                    end
                    else if(block4_locate == 2'b01)
                    begin
                        //$display("block4: 01");
                        if(incond1)
                        begin
                            i <=0;
                            col <=4;
                            incond1 <= 0;
                        end
                        mem1flag <= 0;
                        memory1[i*8 + col] <= data_write;
                        i <= i + 1;
                        if (i == 3)
                        begin
                            i <= 0;
                            col <= col + 1;
                            if (col == 7)
                            begin
                                //if(changeflag == 1)
                                flag <= 0;
                                col <= 0;
                                i <= 4;
                                modeSave <= mode;
                                block4_locate <= 2'b10;
                                incond1 <=1;
                            end
                        end
                    end

                    else if(block4_locate == 2'b10)
                    begin
                        //$display("block4: 10");
                        if(incond2)
                        begin
                            i <=4;
                            col <=0;
                            incond2 <= 0;
                        end
                        mem1flag <= 0;
                        memory1[i*8 + col] <= data_write;
                        i <= i + 1;
                        if (i == 7)
                        begin
                            i <= 4;
                            col <= col + 1;
                            if (col == 3)
                            begin
                                //if(changeflag == 1)
                                flag <= 0;
                                col <= 4;
                                i <= 4;
                                modeSave <= mode;
                                block4_locate <= 2'b11;
                                incond2 <= 1;
                            end
                        end
                    end
                    else if(block4_locate == 2'b11)
                    begin
                        //$display("block4: 11");
                        if(incond3)
                        begin
                            i <=4;
                            col <=4;
                            incond3 <= 0;
                        end

                        mem1flag <= 0;
                        memory1[i*8 + col] <= data_write;
                        i <= i + 1;
                        if (i == 7)
                        begin
                            i <= 4;
                            col <= col + 1;
                            if (col == 7)
                            begin
                                //if(changeflag == 1)
                                flag <= 1;
                                col <= 0;
                                i <= 0;
                                modeSave <= mode;
                                block4_locate <= 2'b00;
                                incond3 <= 1;
                                block00rStart <= 1;
                                readenabletmp <= 1;
                            end
                        end
                        /*if((col == 5) && (i == 6))
                        begin
                            block00rStart <= 1;
                            readenabletmp <= 1;
                        end*/
                    end
                end

                else
                begin
                    if(block4_locate == 2'b00)
                    begin
                        //$display("flag = 1, 1st");
                        //$display("i, col: ", i, col);
                        if(incond0)
                        begin
                            i <=0;
                            col <=0;
                            incond0 <= 0;
                        end
                        //$display("data_write: ", data_write);
                        mem2flag <= 0;
                        memory2[i*8 + col] <= data_write;
                        i <= i + 1;
                        if (i == 3)
                        begin
                            i <= 0;
                            col <= col + 1;
                            if (col == 3)
                            begin
                                //if(changeflag == 1)
                                flag <= 1;
                                col <= 4;
                                i <= 0;
                                modeSave <= mode;
                                block4_locate <= 2'b01;
                                incond0 <= 1;
                                //$display("ininin");
                                readenabletmp <= 1;
                                block00rStart <= 1;
                            end
                        end
                        /*if((col == 2) && (i == 1))
                        begin
                            readenabletmp <= 1;
                            block00rStart <= 1;
                        end*/
                    end
                    else if(block4_locate == 2'b01)
                    begin
                        //$display("flag = 1, 2rd");
                        if(incond1)
                        begin
                            i <=0;
                            col <=4;
                            incond1 <= 0;
                        end
                        mem2flag <= 0;
                        memory2[i*8 + col] <= data_write;
                        i <= i + 1;
                        if (i == 3)
                        begin
                            i <= 0;
                            col <= col + 1;
                            if (col == 7)
                            begin
                                //if(changeflag == 1)
                                flag <= 1;
                                col <= 0;
                                i <= 4;
                                modeSave <= mode;
                                block4_locate <= 2'b10;
                                incond1 <= 1;
                            end
                        end
                    end

                    else if(block4_locate == 2'b10)
                    begin
                        if(incond2)
                        begin
                            i <=4;
                            col <=0;
                            incond2 <= 0;
                        end
                        mem2flag <= 0;
                        memory2[i*8 + col] <= data_write;
                        i <= i + 1;
                        if (i == 7)
                        begin
                            i <= 4;
                            col <= col + 1;
                            if (col == 3)
                            begin
                                //if(changeflag == 1)
                                flag <= 1;
                                col <= 4;
                                i <= 4;
                                modeSave <= mode;
                                block4_locate <= 2'b11;
                                incond2 <= 1;
                            end
                        end
                    end
                    else if(block4_locate == 2'b11)
                    begin
                        if(incond3)
                        begin
                            i <=4;
                            col <=4;
                            incond3 <= 0;
                        end
                        mem2flag <= 0;
                        memory2[i*8 + col] <= data_write;
                        i <= i + 1;
                        if (i == 7)
                        begin
                            i <= 4;
                            col <= col + 1;
                            if (col == 7)
                            begin
                                //if(changeflag == 1)
                                flag <= 0;
                                col <= 0;
                                i <= 0;
                                modeSave <= mode;
                                block4_locate <= 2'b00;
                                incond3 <= 1;
                                block00rStart <= 1;
                                readenabletmp <= 1;
                            end
                        end
                        /*if((col == 5) && (i == 6))
                        begin
                            block00rStart <= 1;
                            readenabletmp <= 1;
                        end*/
                    end
                end

            end
            //if(modeSave != mode)
                //tmpmode = modeSave;
        end
        if(readenabletmp == 1)
        begin
            //$display("readenabletmp");
            if(tmpmode == 1)
            begin
                //$display("intmpmode");
                if(readflag == 1)
                begin
                    //changeflag <= 0;
                    //$display("block1");
                    data_read <= memory2[row *8 + j];
                    j <= j + 1;
                    if (j == 7)
                    begin
                        j <= 0;
                        row <= row + 1;
                        if(row == 7)
                        begin
                            row <= 0;
                            //changeflag <= 1;
                            readflag <= 0;
                            if(mem1flag == 0)
                                tmpmode <= 0;
                            else if(mem1flag == 1)
                                tmpmode <= 1;
                        end
                    end

                end
                else
                begin
                    //$display("inreadflag");
                    //changeflag <= 0;
                    //$display("block2");
                    //$display("readflag: ", readflag);
                    data_read <= memory1[row *8 + j];
                    //$display("j, row", j, row);
                    j <= j + 1;
                    if (j == 7)
                    begin
                        j <= 0;
                        row <= row + 1;
                        if(row == 7)
                        begin
                            //$display("OOOOOO");
                            row <= 0;
                            //changeflag <= 1;
                            readflag <= 1;
                            if(mem2flag == 0)
                                tmpmode <= 0;
                            else if(mem2flag == 1)
                                tmpmode <= 1;
                        end
                    end

                end
            end
            else
            begin
                //$display("tmpmode");
                if(readflag == 1)
                begin
                    //$display("block3");
                    if(block00rStart == 1)
                    begin
                        //$display("in1");
                        /*if((j == 3) && (row == 3)&&(counter == 0))
                        begin
                            j = 0;
                            row =0;
                            counter = 1;
                        end
                        */
                        data_read <= memory2[row*8 + j];
                        j <= j + 1;
                        if (j == 3)
                        begin
                            j <= 0;
                            row <= row + 1;
                            if(row == 3)
                            begin
                                readflag <= 1;
                                //changeflag <=1;
                                if(mem2flag == 0)
                                    tmpmode <= 0;
                                else if(mem2flag == 1)
                                    tmpmode <= 1;
                                counter = 0;
                                j <= 4;
                                row <= 0;
                                //$display("Hello");
                                block01rStart <= 1;
                                block00rStart <= 0;
                            end
                        end
                    end
                    else if(block01rStart == 1)
                    begin
                        //$display("in2");
                        /*if((j == 3) && (row == 3)&&(counter == 0))
                        begin
                            j = 4;
                            row =0;
                            counter = 1;
                        end
                        */
                        data_read <= memory2[row*8 + j];
                        j <= j + 1;
                        if (j == 7)
                        begin
                            j <= 4;
                            row <= row + 1;
                            if(row == 3)
                            begin
                                j <= 0;
                                row <= 4;
                                readflag <= 1;
                                //changeflag <=1;
                                /*if(mem2flag == 0)
                                    tmpmode <= 0;
                                else if(mem2flag == 1)
                                    tmpmode <= 1;*/
                                counter = 0;
                                block10rStart <= 1;
                                block01rStart <= 0;
                            end
                        end
                    end

                    else if(block10rStart == 1)
                    begin
                        /*if((j == 3) && (row == 7)&&(counter == 0))
                        begin
                            j = 0;
                            row =4;
                            counter = 1;
                        end
                        */
                        //$display("in3");
                        data_read <= memory2[row*8 + j];
                        j <= j + 1;
                        if (j == 3)
                        begin
                            j <= 0;
                            row <= row + 1;
                            if(row == 7)
                            begin
                                row <= 4;
                                j <= 4;
                                readflag <= 1;
                                //changeflag <=1;
                                /*if(mem2flag == 0)
                                    tmpmode <= 0;
                                else if(mem2flag == 1)
                                    tmpmode <= 1;*/
                                counter = 0;
                                block11rStart <= 1;
                                block10rStart <= 0;
                            end
                        end
                    end
                    else if(block11rStart == 1)
                    begin
                        /*if((j == 7) && (row == 7)&&(counter == 0))
                        begin
                            j = 4;
                            row = 4;
                            counter = 1;
                        end
                        */
                        //$display("in4");
                        data_read <= memory2[row*8 + j];
                        j <= j + 1;
                        if (j == 7)
                        begin
                            j <= 4;
                            row <= row + 1;
                            if(row == 7)
                            begin
                                readflag <= 0;
                                //changeflag <=1;
                                if(mem1flag == 0)
                                    tmpmode <= 0;
                                else if(mem1flag == 1)
                                    tmpmode <= 1;
                                counter = 0;
                                row <= 0;
                                j <= 0;
                                block11rStart <= 0;
                            end
                        end
                    end
                end
                else
                begin
                    //$display("block4");
                    if(block00rStart == 1)
                    begin
                        //$display("in1");
                        /*if((j == 3) && (row == 3)&&(counter == 0))
                        begin
                            j = 0;
                            row =0;
                            counter = 1;
                        end
                        */
                        data_read <= memory1[row*8 + j];
                        j <= j + 1;
                        if (j == 3)
                        begin
                            j <= 0;
                            row <= row + 1;
                            if(row == 3)
                            begin
                                readflag <= 0;
                                //changeflag <=1;
                                if(mem1flag == 0)
                                    tmpmode <= 0;
                                else if(mem1flag == 1)
                                    tmpmode <= 1;
                                counter = 0;
                                j <= 4;
                                row <= 0;
                                //$display("Hello");
                                block01rStart <= 1;
                                block00rStart <= 0;
                            end
                        end
                    end
                    else if(block01rStart == 1)
                    begin
                        //$display("in2");
                        /*if((j == 3) && (row == 3)&&(counter == 0))
                        begin
                            j = 4;
                            row =0;
                            counter = 1;
                        end
                        */
                        data_read <= memory1[row*8 + j];
                        j <= j + 1;
                        if (j == 7)
                        begin
                            j <= 4;
                            row <= row + 1;
                            if(row == 3)
                            begin
                                j <= 0;
                                row <= 4;
                                readflag <= 0;
                                //changeflag <=1;
                                /*if(mem1flag == 0)
                                    tmpmode <= 0;
                                else if(mem1flag == 1)
                                    tmpmode <= 1;*/
                                counter = 0;
                                block10rStart <= 1;
                                block01rStart <= 0;
                            end
                        end
                    end

                    else if(block10rStart == 1)
                    begin
                        /*if((j == 3) && (row == 7)&&(counter == 0))
                        begin
                            j = 0;
                            row =4;
                            counter = 1;
                        end
                        */
                        //$display("in3");
                        data_read <= memory1[row*8 + j];
                        j <= j + 1;
                        if (j == 3)
                        begin
                            j <= 0;
                            row <= row + 1;
                            if(row == 7)
                            begin
                                row <= 4;
                                j <= 4;
                                readflag <= 0;
                                //changeflag <=1;
                                /*if(mem1flag == 0)
                                    tmpmode <= 0;
                                else if(mem1flag == 1)
                                    tmpmode <= 1;*/
                                counter = 0;
                                block11rStart <= 1;
                                block10rStart <= 0;
                            end
                        end
                    end
                    else if(block11rStart == 1)
                    begin
                        /*if((j == 7) && (row == 7)&&(counter == 0))
                        begin
                            j = 4;
                            row = 4;
                            counter = 1;
                        end
                        */
                        //$display("in4");
                        data_read <= memory1[row*8 + j];
                        j <= j + 1;
                        if (j == 7)
                        begin
                            j <= 4;
                            row <= row + 1;
                            if(row == 7)
                            begin
                                readflag <= 1;
                                //changeflag <=1;
                                if(mem2flag == 0)
                                    tmpmode <= 0;
                                else if(mem2flag == 1)
                                    tmpmode <= 1;
                                counter = 0;
                                row <= 0;
                                j <= 0;
                                block11rStart <= 0;
                            end
                        end
                    end
                end
            end
        end
        outmode <= tmpmode;
        readenable <= readenabletmp;
        end
    end



endmodule
