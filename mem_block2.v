module mem_new(data_write, enable, clk, reset, mode, data_read, outmode, readenable);
    input wire signed[15:0] data_write;
    input enable;
    input clk;
    input reset;
    input mode;
    output reg signed [15:0] data_read;
    output reg outmode;
    output reg readenable;
    reg signed [15:0] memory1[0:31];
    reg signed [15:0] memory2[0:31];
    reg signed [15:0] memory3[0:31];
    reg modeSave;
    reg changeflag;
    reg incond0;
    reg incond1;
    reg incond2;
    reg incond3;
    reg incond4;
    reg block00rStart;
    reg block01rStart;
    reg block02rStart;
    reg block03rStart;
    reg symbol;
    reg tmpmode;
    reg readenabletmp;
    reg mem1flag;
    reg mem2flag;
    reg mem3flag;
    reg horizen;
    reg mem1horizen;
    reg mem2horizen;
    reg mem3horizen;

    reg[1:0] readflag;
    reg[1:0] flag;
    reg[1:0] block4_locate;
    reg origin;
    integer i, j, row, col;

    always@ (posedge clk or negedge reset)
    begin
        if(reset == 0)
        begin
            mem1horizen <= 0;
            mem2horizen <= 0;
            mem3horizen <= 0;
            horizen <= 0;
            block00rStart <= 0;
            block01rStart <= 0;
            block02rStart <= 0;
            block03rStart <= 0;
            symbol <= 0;
            readflag <= 2'd0;
            incond0 <= 1;
            incond1 <= 1;
            incond2 <= 1;
            incond3 <= 1;
            mem1flag <= 0;
            mem2flag <= 0;
            mem3flag <= 0;
            block4_locate <= 2'b00;
            changeflag <= 0;
            readenabletmp <= 0;
            flag <= 2'd0;
            row <= 0;
            col <= 0;
            origin <= 0;
            i <= 0;
            j <= 0;
        end
        else
        begin
        if (enable == 1)
        begin
            if(origin == 0)
            begin
                tmpmode <= mode;
                origin <= 1;
            end

            if (mode == 1)
            begin
                if (flag == 2'd0)
                begin
                    mem1flag <= 1;
                    mem2flag <= 1;
                    if(incond4)
                    begin
                        i <= 0;
                        col <= 0;
                        incond4 <= 0;
                    end

                    if(horizen == 1)
                    begin
                        if (i < 4)
                        begin
                            memory1[col * 4 + i] <= data_write;
                            i <= i + 1;
                        end
                        else
                        begin
                            memory2[col * 4 + i - 4] <= data_write;
                            i <= i + 1;
                            if(i == 7)
                            begin
                                i <= 0;
                                col <= col + 1;
                                if(col == 7)
                                begin
                                    col <= 0;
                                    flag <= 2'd2;
                                    modeSave <= mode;
                                    incond4 <= 1;
                                    mem1flag <= 1;
                                    mem2flag <= 1;
                                    mem1horizen <= 1;
                                    mem2horizen <= 1;
                                    horizen <= 0;

                                    if(symbol == 0)
                                    begin
                                        readenabletmp <= 1;
                                        readflag <= 0;
                                        symbol <= 1;
                                    end
                                end
                            end
                        end
                    end
                    else if(horizen == 0)
                    begin
                        if (i < 4)
                        begin
                            memory1[col * 4 + i] <= data_write;
                            col <= col + 1;
                            if(col == 7)
                            begin
                                col <= 0;
                                i <= i + 1;
                            end
                        end
                        else
                        begin
                            memory2[col * 4 + i - 4] <= data_write;
                            col <= col + 1;
                            if(col == 7)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 7)
                                begin
                                    i <= 0;
                                    flag <= 2'd2;
                                    modeSave <= mode;
                                    incond4 <= 1;
                                    mem1flag <= 1;
                                    mem2flag <= 1;
                                    horizen <= 1;
                                    mem1horizen <= 0;
                                    mem2horizen <= 0;
                                    if(symbol == 0)
                                    begin
                                        readenabletmp <= 1;
                                        readflag <= 2'b00;
                                        symbol <= 1;
                                    end
                                end
                            end
                        end
                    end
                end

                else if(flag == 2'd1)
                begin
                    mem2flag <= 1;
                    mem3flag <= 1;
                    if(incond4)
                    begin
                        i <= 0;
                        col <= 0;
                        incond4 <= 0;
                    end

                    if(horizen == 1)
                    begin

                        if (i < 4)
                        begin
                            memory2[col * 4 + i] <= data_write;
                            i <= i + 1;
                        end
                        else
                        begin
                            memory3[col * 4 + i - 4] <= data_write;
                            i <= i + 1;
                            if(i == 7)
                            begin
                                i <= 0;
                                col <= col + 1;
                                if(col == 7)
                                begin
                                    col <= 0;
                                    flag <= 2'd0;
                                    modeSave <= mode;
                                    incond4 <= 1;
                                    mem2flag <= 1;
                                    mem3flag <= 1;
                                    horizen <= 0;
                                    mem2horizen <= 1;
                                    mem3horizen <= 1;
                                    if(symbol == 0)
                                    begin
                                        readenabletmp <= 1;
                                        readflag <= 2'b00;
                                        symbol <= 1;
                                    end
                                end
                            end
                        end
                    end
                    else if(horizen == 0)
                    begin

                        if (i < 4)
                        begin
                            memory2[col * 4 + i] <= data_write;
                            col <= col + 1;
                            if(col == 7)
                            begin
                                col <= 0;
                                i <= i + 1;
                            end
                        end
                        else
                        begin
                            memory3[col * 4 + i - 4] <= data_write;
                            col <= col + 1;
                            if(col == 7)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 7)
                                begin
                                    i <= 0;
                                    flag <= 2'd0;
                                    modeSave <= mode;
                                    incond4 <= 1;
                                    mem2flag <= 1;
                                    mem3flag <= 1;
                                    horizen <= 1;
                                    mem2horizen <= 0;
                                    mem3horizen <= 0;
                                    if(symbol == 0)
                                    begin
                                        readenabletmp <= 1;
                                        readflag <= 2'b00;
                                        symbol <= 1;
                                    end
                                end
                            end
                        end
                    end
                end

                else
                begin

                    mem1flag <= 1;
                    mem3flag <= 1;
                    if(incond4)
                    begin
                        i <= 0;
                        col <= 0;
                        incond4 <= 0;
                    end

                    if(horizen == 1)
                    begin

                        if (i < 4)
                        begin
                            memory3[col * 4 + i] <= data_write;
                            i <= i + 1;
                        end
                        else
                        begin
                            memory1[col * 4 + i - 4] <= data_write;
                            i <= i + 1;
                            if(i == 7)
                            begin
                                i <= 0;
                                col <= col + 1;
                                if(col == 7)
                                begin
                                    col <= 0;
                                    flag <= 2'd1;
                                    modeSave <= mode;
                                    incond4 <= 1;
                                    mem3flag <= 1;
                                    mem1flag <= 1;
                                    horizen <= 0;
                                    mem3horizen <= 1;
                                    mem1horizen <= 1;
                                    if(symbol == 0)
                                    begin
                                        readenabletmp <= 1;
                                        readflag <= 2'b00;
                                        symbol <= 1;
                                    end
                                end
                            end
                        end
                    end
                    else if(horizen == 0)
                    begin

                        if (i < 4)
                        begin
                            memory3[col * 4 + i] <= data_write;
                            col <= col + 1;
                            if(col == 7)
                            begin
                                col <= 0;
                                i <= i + 1;
                            end
                        end
                        else
                        begin
                            memory1[col * 4 + i - 4] <= data_write;
                            col <= col + 1;
                            if(col == 7)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 7)
                                begin
                                    i <= 0;
                                    flag <= 2'd1;
                                    modeSave <= mode;
                                    incond4 <= 1;
                                    mem3flag <= 1;
                                    mem1flag <= 1;
                                    horizen <= 1;
                                    mem3horizen <= 0;
                                    mem1horizen <= 0;
                                    if(symbol == 0)
                                    begin
                                        readenabletmp <= 1;
                                        readflag <= 2'b00;
                                        symbol <= 1;
                                    end
                                end
                            end
                        end
                    end
                end

            end

            else//4x4
            begin
                if(flag == 2'd0)
                begin
                    if(block4_locate == 2'b00)
                    begin
                        mem1flag <= 0;
                        if(incond0)
                        begin
                            i <= 0;
                            col <= 0;
                            incond0 <= 0;
                        end


                        if (horizen == 1)
                        begin

                            memory1[i*4 + col] <= data_write;
                            col <= col + 1;
                            if(col == 3)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 3)
                                begin
                                    flag <= 2'd0;
                                    col <= 0;
                                    i <= 4;
                                    modeSave <= mode;
                                    mem1flag <= 0;
                                    incond1 <= 1;
                                    mem1horizen <= 1;
                                    block4_locate <= 2'b01;
                                end
                            end
                        end
                        else if(horizen == 0)
                        begin

                            memory1[i*4 + col] <= data_write;
                            i <= i + 1;
                            if(i == 3)
                            begin
                                i <= 0;
                                col <= col + 1;
                                if(col == 3)
                                begin
                                    flag <= 2'd0;
                                    col <= 0;
                                    i <= 4;
                                    modeSave <= mode;
                                    mem1flag <= 0;
                                    incond1 <= 1;
                                    mem1horizen <= 0;
                                    block4_locate <= 2'b01;
                                end
                            end
                        end

                    end
                    else if(block4_locate == 2'b01)
                    begin
                        mem1flag <= 0;
                        if(incond1)
                        begin
                            i <= 4;
                            col <= 0;
                            incond1 <= 0;
                        end

                        if(horizen == 1)
                        begin
                            memory1[i*4 + col] <= data_write;
                            col <= col + 1;
                            if(col == 3)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 7)
                                begin
                                    flag <= 2'd0;
                                    col <= 0;
                                    i <= 0;
                                    mem1flag <= 0;
                                    modeSave <= mode;
                                    incond1 <= 1;
                                    block4_locate <= 2'b10;
                                end
                            end
                        end
                        else if(horizen == 0)
                        begin
                            memory1[i*4 + col] <= data_write;
                            i <= i + 1;
                            if(i == 7)
                            begin
                                i <= 4;
                                col <= col + 1;
                                if(col == 3)
                                begin
                                    flag <= 2'd0;
                                    col <= 0;
                                    i <= 0;
                                    mem1flag <= 0;
                                    modeSave <= mode;
                                    incond1 <= 1;
                                    block4_locate <= 2'b10;
                                end
                            end
                        end

                    end

                    else if(block4_locate == 2'b10)
                    begin
                        mem2flag <= 0;
                        if (incond2)
                        begin
                            i <= 0;
                            col <= 0;
                            incond2 <= 0;
                        end

                        if(horizen == 1)
                        begin

                            memory2[i*4 + col] <= data_write;
                            col <= col + 1;
                            if(col == 3)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 3)
                                begin
                                    flag <= 2'd0;
                                    col <= 0;
                                    i <= 4;
                                    mem2flag <= 0;
                                    modeSave <= mode;
                                    mem2horizen <= 1;
                                    incond2 <= 1;
                                    block4_locate <= 2'b11;
                                end
                            end
                        end
                        else if(horizen == 0)
                        begin

                            memory2[i*4 + col] <= data_write;
                            i <= i + 1;
                            if(i == 3)
                            begin
                                i <= 0;
                                col <= col + 1;
                                if(col == 3)
                                begin
                                    flag <= 2'd0;
                                    col <= 0;
                                    i <= 4;
                                    mem2flag <= 0;
                                    modeSave <= mode;
                                    mem2horizen <= 0;
                                    incond2 <= 1;
                                    block4_locate <= 2'b11;
                                end
                            end
                        end
                    end

                    else if(block4_locate == 2'b11)
                    begin
                        mem2flag <= 0;
                        if(incond3)
                        begin
                            i <= 4;
                            col <= 0;
                            incond3 <= 0;
                        end


                        if(horizen == 1)
                        begin
                            memory2[i*4 + col] <= data_write;
                            col <= col + 1;
                            if(col == 3)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 7)
                                begin
                                    flag <= 2'd2;
                                    col <= 0;
                                    i <= 0;

                                    mem2flag <= 0;
                                    horizen <= 0;
                                    modeSave <= mode;
                                    incond3 <= 1;
                                    block4_locate <= 2'b00;
                                    block00rStart <= 1;
                                    readenabletmp <= 1;
                                end
                            end
                        end
                        else if(horizen == 0)
                        begin
                            memory2[i*4 + col] <= data_write;
                            i <= i + 1;
                            if(i == 7)
                            begin
                                i <= 4;
                                col <= col + 1;
                                if(col == 3)
                                begin
                                    flag <= 2'd2;
                                    col <= 0;
                                    i <= 0;

                                    mem2flag <= 0;
                                    horizen <= 1;
                                    modeSave <= mode;
                                    incond3 <= 1;
                                    block4_locate <= 2'b00;
                                    block00rStart <= 1;
                                    readenabletmp <= 1;
                                end
                            end
                        end
                    end

                end
                else if(flag == 2'd1)
                begin
                    //$display("flag 1 4x4");
                    if(block4_locate == 2'b00)
                    begin
                        $display("b1");
                        mem2flag <= 0;
                        if(incond0)
                        begin
                            i <= 0;
                            col <= 0;
                            incond0 <= 0;
                        end


                        if (horizen == 1)
                        begin

                            memory2[i*4 + col] <= data_write;
                            col <= col + 1;
                            if(col == 3)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 3)
                                begin
                                    flag <= 2'd1;
                                    col <= 0;
                                    i <= 4;
                                    mem2flag <= 0;
                                    modeSave <= mode;
                                    mem2horizen <= 1;
                                    incond1 <= 1;
                                    block4_locate <= 2'b01;
                                end
                            end
                        end
                        else if(horizen == 0)
                        begin

                            memory2[i*4 + col] <= data_write;
                            i <= i + 1;
                            if(i == 3)
                            begin
                                i <= 0;
                                col <= col + 1;
                                if(col == 3)
                                begin
                                    flag <= 2'd1;
                                    col <= 0;
                                    i <= 4;
                                    mem2flag <= 0;
                                    modeSave <= mode;
                                    mem2horizen <= 0;
                                    incond1 <= 1;
                                    block4_locate <= 2'b01;
                                end
                            end
                        end

                    end
                    else if(block4_locate == 2'b01)
                    begin
                        //$display("b2");
                        mem2flag <= 0;
                        if(incond1)
                        begin
                            i <= 4;
                            col <= 0;
                            incond1 <= 0;
                        end

                        if(horizen == 1)
                        begin
                            memory2[i*4 + col] <= data_write;
                            col <= col + 1;
                            if(col == 3)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 7)
                                begin
                                    flag <= 2'd1;
                                    col <= 0;
                                    i <= 0;
                                    col <= 0;
                                    mem2flag <= 0;
                                    modeSave <= mode;
                                    incond1 <= 1;
                                    block4_locate <= 2'b10;
                                end
                            end
                        end
                        else if(horizen == 0)
                        begin
                            memory2[i*4 + col] <= data_write;
                            i <= i + 1;
                            if(i == 7)
                            begin
                                i <= 4;
                                col <= col + 1;
                                if(col == 3)
                                begin
                                    flag <= 2'd1;
                                    col <= 0;
                                    i <= 0;
                                    col <= 0;
                                    mem2flag <= 0;
                                    modeSave <= mode;
                                    incond1 <= 1;
                                    block4_locate <= 2'b10;
                                end
                            end
                        end

                    end

                    else if(block4_locate == 2'b10)
                    begin
                        mem3flag <= 0;
                        if (incond2)
                        begin
                            i <= 0;
                            col <= 0;
                            incond2 <= 0;
                        end

                        if(horizen == 1)
                        begin

                            memory3[i*4 + col] <= data_write;
                            col <= col + 1;
                            if(col == 3)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 3)
                                begin
                                    flag <= 2'd1;
                                    col <= 0;
                                    i <= 4;
                                    mem3flag <= 0;
                                    modeSave <= mode;
                                    incond2 <= 1;
                                    mem3horizen <= 1;
                                    block4_locate <= 2'b11;
                                end
                            end
                        end
                        else if(horizen == 0)
                        begin

                            memory3[i*4 + col] <= data_write;
                            i <= i + 1;
                            if(i == 3)
                            begin
                                i <= 0;
                                col <= col + 1;
                                if(col == 3)
                                begin
                                    flag <= 2'd1;
                                    col <= 0;
                                    i <= 4;
                                    mem3flag <= 0;
                                    modeSave <= mode;
                                    mem3horizen <= 0;
                                    incond2 <= 1;
                                    block4_locate <= 2'b11;
                                end
                            end
                        end
                    end

                    else if(block4_locate == 2'b11)
                    begin
                        mem3flag <= 0;
                        if(incond3)
                        begin
                            i <= 4;
                            col <= 0;
                            incond3 <= 0;
                        end


                        if(horizen == 1)
                        begin
                            memory3[i*4 + col] <= data_write;
                            col <= col + 1;
                            if(col == 3)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 7)
                                begin
                                    flag <= 2'd0;
                                    col <= 0;
                                    i <= 4;
                                    col <= 0;
                                    horizen <= 0;
                                    mem3flag <= 0;
                                    modeSave <= mode;
                                    incond3 <= 1;
                                    block4_locate <= 2'b00;
                                    block00rStart <= 1;
                                    readenabletmp <= 1;
                                end
                            end
                        end
                        else if(horizen == 0)
                        begin
                            memory3[i*4 + col] <= data_write;
                            i <= i + 1;
                            if(i == 7)
                            begin
                                i <= 4;
                                col <= col + 1;
                                if(col == 3)
                                begin
                                    flag <= 2'd0;
                                    col <= 0;
                                    i <= 0;
                                    col <= 0;
                                    horizen <= 1;
                                    mem3flag <= 0;
                                    modeSave <= mode;
                                    incond3 <= 1;
                                    block4_locate <= 2'b00;
                                    block00rStart <= 1;
                                    readenabletmp <= 1;
                                end
                            end
                        end
                    end

                end
                else
                begin
                    if(block4_locate == 2'b00)
                    begin
                        mem3flag <= 0;
                        if(incond0)
                        begin
                            i <= 0;
                            col <= 0;
                            incond0 <= 0;
                        end


                        if (horizen == 1)
                        begin

                            memory3[i*4 + col] <= data_write;
                            col <= col + 1;
                            if(col == 3)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 3)
                                begin
                                    flag <= 2'd2;
                                    col <= 0;
                                    i <= 4;
                                    mem3flag <= 0;
                                    modeSave <= mode;
                                    mem3horizen <= 1;
                                    incond1 <= 1;
                                    block4_locate <= 2'b01;
                                end
                            end
                        end
                        else if(horizen == 0)
                        begin

                            memory3[i*4 + col] <= data_write;
                            i <= i + 1;
                            if(i == 3)
                            begin
                                i <= 0;
                                col <= col + 1;
                                if(col == 3)
                                begin
                                    flag <= 2'd2;
                                    col <= 0;
                                    i <= 4;
                                    mem3flag <= 0;
                                    modeSave <= mode;
                                    mem3horizen <= 0;
                                    incond1 <= 1;
                                    block4_locate <= 2'b01;
                                end
                            end
                        end

                    end
                    else if(block4_locate == 2'b01)
                    begin
                        mem3flag <= 0;
                        if(incond1)
                        begin
                            i <= 4;
                            col <= 0;
                            incond1 <= 0;
                        end


                        if(horizen == 1)
                        begin
                            memory3[i*4 + col] <= data_write;
                            col <= col + 1;
                            if(col == 3)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 7)
                                begin
                                    flag <= 2'd2;
                                    col <= 0;
                                    i <= 0;
                                    col <= 0;
                                    mem3flag <= 0;
                                    modeSave <= mode;
                                    incond1 <= 1;
                                    block4_locate <= 2'b10;
                                end
                            end
                        end
                        else if(horizen == 0)
                        begin
                            memory3[i*4 + col] <= data_write;
                            i <= i + 1;
                            if(i == 7)
                            begin
                                i <= 4;
                                col <= col + 1;
                                if(col == 3)
                                begin
                                    flag <= 2'd2;
                                    col <= 0;
                                    i <= 0;
                                    col <= 0;
                                    mem3flag <= 0;
                                    modeSave <= mode;
                                    incond1 <= 1;
                                    block4_locate <= 2'b10;
                                end
                            end
                        end

                    end

                    else if(block4_locate == 2'b10)
                    begin
                        mem1flag <= 0;
                        if (incond2)
                        begin
                            i <= 0;
                            col <= 0;
                            incond2 <= 0;
                        end

                        if(horizen == 1)
                        begin

                            memory1[i*4 + col] <= data_write;
                            col <= col + 1;
                            if(col == 3)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 3)
                                begin
                                    flag <= 2'd2;
                                    col <= 0;
                                    i <= 4;
                                    mem1flag <= 0;
                                    modeSave <= mode;
                                    mem1horizen <= 1;
                                    incond2 <= 1;
                                    block4_locate <= 2'b11;
                                end
                            end
                        end
                        else if(horizen == 0)
                        begin

                            memory1[i*4 + col] <= data_write;
                            i <= i + 1;
                            if(i == 3)
                            begin
                                i <= 0;
                                col <= col + 1;
                                if(col == 3)
                                begin
                                    flag <= 2'd2;
                                    col <= 0;
                                    i <= 4;
                                    mem1flag <= 0;
                                    modeSave <= mode;
                                    mem1horizen <= 0;
                                    incond2 <= 1;
                                    block4_locate <= 2'b11;
                                end
                            end
                        end
                    end

                    else if(block4_locate == 2'b11)
                    begin
                        mem1flag <= 0;
                        if(incond3)
                        begin
                            i <= 4;
                            col <= 0;
                            incond3 <= 0;
                        end

                        if(horizen == 1)
                        begin
                            memory1[i*4 + col] <= data_write;
                            col <= col + 1;
                            if(col == 3)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if(i == 7)
                                begin
                                    flag <= 2'd1;
                                    col <= 0;
                                    i <= 0;
                                    col <= 0;
                                    horizen <= 0;
                                    modeSave <= mode;
                                    incond3 <= 1;
                                    mem1flag <= 0;
                                    block4_locate <= 2'b00;
                                    block00rStart <= 1;
                                    readenabletmp <= 1;
                                end
                            end
                        end
                        else if(horizen == 0)
                        begin
                            memory1[i*4 + col] <= data_write;
                            i <= i + 1;
                            if(i == 7)
                            begin
                                i <= 4;
                                col <= col + 1;
                                if(col == 3)
                                begin
                                    flag <= 2'd1;
                                    col <= 0;
                                    i <= 0;
                                    col <= 0;
                                    horizen <= 1;
                                    modeSave <= mode;
                                    incond3 <= 1;
                                    mem1flag <= 0;
                                    block4_locate <= 2'b00;
                                    block00rStart <= 1;
                                    readenabletmp <= 1;
                                end
                            end
                        end
                    end

                end

            end

        end

        end
    end

    always@(posedge clk)
    begin
        if(readenabletmp == 1)
        begin
            if(tmpmode == 1)
            begin
                if(readflag == 2'b00)
                begin
                    if((mem2horizen == 1))
                    begin

                        if (j < 4)
                        begin
                            data_read <= memory1[row * 4 + j];
                            row <= row + 1;
                            if(row == 7)
                            begin
                                row <= 0;
                                j <= j + 1;
                            end
                        end
                        else
                        begin
                            data_read <= memory2[row * 4 + j - 4];
                            row <= row + 1;
                            if(row == 7)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 7)
                                begin
                                    j <= 0;
                                    readflag <= 2'b10;
                                    if(mem3flag == 0)
                                        tmpmode <= 0;
                                    else if(mem3flag == 1)
                                        tmpmode <= 1;
                                end
                            end
                        end
                    end
                    else
                    begin
                        if (j < 4)
                        begin
                            data_read <= memory1[row * 4 + j];
                            j <= j + 1;
                        end
                        else
                        begin
                            data_read <= memory2[row * 4 + j - 4];
                            j <= j + 1;
                            if(j == 7)
                            begin
                                j <= 0;
                                row <= row + 1;
                                if(row == 7)
                                begin
                                    row <= 0;

                                    readflag <= 2'b10;
                                    if(mem3flag == 0)
                                        tmpmode <= 0;
                                    else if(mem3flag == 1)
                                        tmpmode <= 1;
                                end
                            end
                        end
                    end
                end
                else if(readflag == 2'b01)
                begin
                    if((mem3horizen == 1))
                    begin
                        if (j < 4)
                        begin
                            data_read <= memory2[row * 4 + j];
                            row <= row + 1;
                            if(row == 7)
                            begin
                                row <= 0;
                                j <= j + 1;
                            end
                        end
                        else
                        begin
                            data_read <= memory3[row * 4 + j - 4];
                            row <= row + 1;
                            if(row == 7)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 7)
                                begin
                                    j <= 0;
                                    readflag <= 2'b00;
                                    if(mem1flag == 0)
                                        tmpmode <= 0;
                                    else if(mem1flag == 1)
                                        tmpmode <= 1;
                                end
                            end
                        end
                    end
                    else
                    begin
                        if (j < 4)
                        begin
                            data_read <= memory2[row * 4 + j];
                            j <= j + 1;
                        end
                        else
                        begin
                            data_read <= memory3[row * 4 + j - 4];
                            j <= j + 1;
                            if(j == 7)
                            begin
                                j <= 0;
                                row <= row + 1;
                                if(row == 7)
                                begin
                                    row <= 0;

                                    readflag <= 2'b00;
                                    if(mem1flag == 0)
                                        tmpmode <= 0;
                                    else if(mem1flag == 1)
                                        tmpmode <= 1;
                                end
                            end
                        end
                    end
                end
                else
                begin
                    //$display("readflag 3\n");
                    if((mem1horizen == 1))
                    begin
                        if (j < 4)
                        begin
                            data_read <= memory3[row * 4 + j];
                            row <= row + 1;
                            if(row == 7)
                            begin
                                row <= 0;
                                j <= j + 1;
                            end
                        end
                        else
                        begin
                            data_read <= memory1[row * 4 + j - 4];
                            row <= row + 1;
                            if(row == 7)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 7)
                                begin
                                    j <= 0;
                                    readflag <= 2'b01;
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
                        if (j < 4)
                        begin
                            data_read <= memory3[row * 4 + j];
                            j <= j + 1;
                        end
                        else
                        begin
                            data_read <= memory1[row * 4 + j - 4];
                            j <= j + 1;
                            if(j == 7)
                            begin
                                j <= 0;
                                row <= row + 1;
                                if(row == 7)
                                begin
                                    row <= 0;

                                    readflag <= 2'b01;

                                    if(mem2flag == 0)
                                        tmpmode <= 0;
                                    else if(mem2flag == 1)
                                        tmpmode <= 1;
                                end
                            end
                        end
                    end
                end
            end
            else
            begin
                if(readflag == 2'b00)
                begin
                    if(block00rStart == 1)
                    begin
                        if(mem1horizen == 1)
                        begin
                            data_read <= memory1[j*4 + row];
                            j <= j + 1;
                            if(j == 3)
                            begin
                                j <= 0;
                                row <= row + 1;
                                if(row == 3)
                                begin
                                    row <= 0;
                                    j <= 4;
                                    block00rStart <= 0;
                                    block01rStart <= 1;
                                end
                            end
                        end
                        else if(mem1horizen == 0)
                        begin
                            data_read <= memory1[j*4 +row];
                            row <= row + 1;
                            if(row == 3)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 3)
                                begin
                                    j <= 4;
                                    row <= 0;
                                    block00rStart <= 0;
                                    block01rStart <= 1;
                                end
                            end
                        end
                    end
                    else if(block01rStart == 1)
                    begin
                        if(mem1horizen == 1)
                        begin
                            data_read <= memory1[j*4 + row];
                            j <= j + 1;
                            if(j == 7)
                            begin
                                j <= 4;
                                row <= row + 1;
                                if(row == 3)
                                begin
                                    row <= 0;
                                    j <= 0;

                                    block01rStart <= 0;
                                    block02rStart <= 1;
                                end
                            end
                        end
                        else if(mem1horizen == 0)
                        begin
                            data_read <= memory1[j*4 + row];
                            row <= row + 1;
                            if(row == 3)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 7)
                                begin
                                    row <= 0;
                                    j <= 0;
                                    block01rStart <= 0;
                                    block02rStart <= 1;
                                end
                            end
                        end
                    end
                    else if(block02rStart == 1)
                    begin
                        if(mem2horizen == 1)
                        begin
                            data_read <= memory2[j*4 + row];
                            j <= j + 1;
                            if(j == 3)
                            begin
                                j <= 0;
                                row <= row + 1;
                                if(row == 3)
                                begin
                                    row <= 0;
                                    j <= 4;
                                    block02rStart <= 0;
                                    block03rStart <= 1;
                                end
                            end
                        end
                        else if(mem2horizen == 0)
                        begin
                            data_read <= memory2[j*4 + row];
                            row <= row + 1;
                            if(row == 3)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 3)
                                begin

                                    row <= 0;
                                    j <= 4;
                                    block02rStart <= 0;
                                    block03rStart <= 1;
                                end
                            end
                        end
                    end
                    else if(block03rStart == 1)
                    begin
                        if(mem2horizen == 1)
                        begin
                            data_read <= memory2[j*4 + row];
                            j <= j + 1;
                            if(j == 7)
                            begin
                                j <= 4;
                                row <= row + 1;
                                if(row == 3)
                                begin
                                    row <= 0;
                                    j <= 0;
                                    readflag <= 2'b10;
                                    block03rStart <= 0;
                                    if(mem3flag == 0)
                                        tmpmode <= 0;
                                    else if(mem3flag == 1)
                                        tmpmode <= 1;

                                end
                            end
                        end
                        else if(mem2horizen == 0)
                        begin
                            data_read <= memory2[j*4 + row];
                            row <= row + 1;
                            if(row == 3)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 7)
                                begin

                                    row <= 0;
                                    j <= 0;
                                    readflag <= 2'b10;
                                    block03rStart <= 0;
                                    if(mem3flag == 0)
                                        tmpmode <= 0;
                                    else if(mem3flag == 1)
                                        tmpmode <= 1;
                                end
                            end
                        end
                    end
                end

                else if(readflag == 2'b01)
                begin
                    if(block00rStart == 1)
                    begin
                        if(mem2horizen == 1)
                        begin
                            data_read <= memory2[j*4 + row];
                            j <= j + 1;
                            if(j == 3)
                            begin
                                j <= 0;
                                row <= row + 1;
                                if(row == 3)
                                begin
                                    row <= 0;
                                    j <= 4;
                                    block00rStart <= 0;
                                    block01rStart <= 1;
                                end
                            end
                        end
                        else if(mem2horizen == 0)
                        begin
                            data_read <= memory2[j*4 +row];
                            row <= row + 1;
                            if(row == 3)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 3)
                                begin
                                    j <= 4;
                                    row <= 0;
                                    block00rStart <= 0;
                                    block01rStart <= 1;
                                end
                            end
                        end
                    end
                    else if(block01rStart == 1)
                    begin
                        if(mem2horizen == 1)
                        begin
                            data_read <= memory2[j*4 + row];
                            j <= j + 1;
                            if(j == 7)
                            begin
                                j <= 4;
                                row <= row + 1;
                                if(row == 3)
                                begin
                                    row <= 0;
                                    j <= 0;

                                    block01rStart <= 0;
                                    block02rStart <= 1;
                                end
                            end
                        end
                        else if(mem2horizen == 0)
                        begin
                            data_read <= memory2[j*4 + row];
                            row <= row + 1;
                            if(row == 3)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 7)
                                begin
                                    row <= 0;
                                    j <= 0;
                                    block01rStart <= 0;
                                    block02rStart <= 1;
                                end
                            end
                        end
                    end
                    else if(block02rStart == 1)
                    begin
                        if(mem3horizen == 1)
                        begin
                            data_read <= memory3[j*4 + row];
                            j <= j + 1;
                            if(j == 3)
                            begin
                                j <= 0;
                                row <= row + 1;
                                if(row == 3)
                                begin
                                    row <= 0;
                                    j <= 4;
                                    block02rStart <= 0;
                                    block03rStart <= 1;
                                end
                            end
                        end
                        else if(mem3horizen == 0)
                        begin
                            data_read <= memory3[j*4 + row];
                            row <= row + 1;
                            if(row == 3)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 3)
                                begin

                                    row <= 0;
                                    j <= 4;
                                    block02rStart <= 0;
                                    block03rStart <= 1;
                                end
                            end
                        end
                    end
                    else if(block03rStart == 1)
                    begin
                        if(mem3horizen == 1)
                        begin
                            data_read <= memory3[j*4 + row];
                            j <= j + 1;
                            if(j == 7)
                            begin
                                j <= 4;
                                row <= row + 1;
                                if(row == 3)
                                begin
                                    row <= 0;
                                    j <= 0;
                                    readflag <= 2'b00;
                                    block03rStart <= 0;
                                    if(mem1flag == 0)
                                        tmpmode <= 0;
                                    else if(mem1flag == 1)
                                        tmpmode <= 1;

                                end
                            end
                        end
                        else if(mem3horizen == 0)
                        begin
                            data_read <= memory3[j*4 + row];
                            row <= row + 1;
                            if(row == 3)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 7)
                                begin

                                    row <= 0;
                                    j <= 0;
                                    readflag <= 2'b00;
                                    block03rStart <= 0;
                                    if(mem1flag == 0)
                                        tmpmode <= 0;
                                    else if(mem1flag == 1)
                                        tmpmode <= 1;
                                end
                            end
                        end
                    end
                end

                else
                begin
                    if(block00rStart == 1)
                    begin
                        if(mem3horizen == 1)
                        begin
                            data_read <= memory3[j*4 + row];
                            j <= j + 1;
                            if(j == 3)
                            begin
                                j <= 0;
                                row <= row + 1;
                                if(row == 3)
                                begin
                                    row <= 0;
                                    j <= 4;
                                    block00rStart <= 0;
                                    block01rStart <= 1;
                                end
                            end
                        end
                        else if(mem3horizen == 0)
                        begin
                            data_read <= memory3[j*4 +row];
                            row <= row + 1;
                            if(row == 3)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 3)
                                begin
                                    j <= 4;
                                    row <= 0;
                                    block00rStart <= 0;
                                    block01rStart <= 1;
                                end
                            end
                        end
                    end
                    else if(block01rStart == 1)
                    begin
                        if(mem3horizen == 1)
                        begin
                            data_read <= memory3[j*4 + row];
                            j <= j + 1;
                            if(j == 7)
                            begin
                                j <= 4;
                                row <= row + 1;
                                if(row == 3)
                                begin
                                    row <= 0;
                                    j <= 0;

                                    block01rStart <= 0;
                                    block02rStart <= 1;
                                end
                            end
                        end
                        else if(mem3horizen == 0)
                        begin
                            data_read <= memory3[j*4 + row];
                            row <= row + 1;
                            if(row == 3)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 7)
                                begin
                                    row <= 0;
                                    j <= 0;
                                    block01rStart <= 0;
                                    block02rStart <= 1;
                                end
                            end
                        end
                    end
                    else if(block02rStart == 1)
                    begin
                        if(mem1horizen == 1)
                        begin
                            data_read <= memory1[j*4 + row];
                            j <= j + 1;
                            if(j == 3)
                            begin
                                j <= 0;
                                row <= row + 1;
                                if(row == 3)
                                begin
                                    row <= 0;
                                    j <= 4;
                                    block02rStart <= 0;
                                    block03rStart <= 1;
                                end
                            end
                        end
                        else if(mem1horizen == 0)
                        begin
                            data_read <= memory1[j*4 + row];
                            row <= row + 1;
                            if(row == 3)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 3)
                                begin

                                    row <= 0;
                                    j <= 4;
                                    block02rStart <= 0;
                                    block03rStart <= 1;
                                end
                            end
                        end
                    end
                    else if(block03rStart == 1)
                    begin
                        if(mem1horizen == 1)
                        begin
                            data_read <= memory1[j*4 + row];
                            j <= j + 1;
                            if(j == 7)
                            begin
                                j <= 4;
                                row <= row + 1;
                                if(row == 3)
                                begin
                                    row <= 0;
                                    j <= 0;
                                    readflag <= 2'b01;
                                    block03rStart <= 0;
                                    if(mem2flag == 0)
                                        tmpmode <= 0;
                                    else if(mem2flag == 1)
                                        tmpmode <= 1;

                                end
                            end
                        end
                        else if(mem1horizen == 0)
                        begin
                            data_read <= memory1[j*4 + row];
                            row <= row + 1;
                            if(row == 3)
                            begin
                                row <= 0;
                                j <= j + 1;
                                if(j == 7)
                                begin

                                    row <= 0;
                                    j <= 0;
                                    readflag <= 2'b01;
                                    block03rStart <= 0;
                                    if(mem2flag == 0)
                                        tmpmode <= 0;
                                    else if(mem2flag == 1)
                                        tmpmode <= 1;
                                end
                            end
                        end
                    end
                end
            end
        end
        outmode <= tmpmode;
        readenable <= readenabletmp;
    end


endmodule
