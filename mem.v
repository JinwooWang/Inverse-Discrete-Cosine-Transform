module mem(input reg[15:0] data_write, input enable, input clk, input mode, output reg[15:0] data_read);
    reg[15:0] memory1[0:63];
    reg[15:0] memory2[0:63];
    reg modeSave;
    reg tmpStore;
    reg changeflag;
    reg readenable;
    reg readflag;

    reg block_wtran1;
    reg block8_rtran1;
    //reg block4_wtran1;
    reg block4_rtran1;
    reg block_wtran2;
    reg block8_rtran2;
    reg[1:0] block4_locate;

    reg mem1flag;//1->8, 0->4
    reg mem2flag;
    //reg block4_wtran2;
    reg block4_rtran2;
    reg origin;
    integer i, j, k1, k2, row, col,counter;
    reg flag;
    initial
    begin
        //mem1flag = 1'b0;
        block4_locate = 2'b00;
        block_wtran1 = 1'b0;//竖着写
        block8_rtran1 = 1'b1;//横着读
        //block4_wtran1 = 1'b0;
        block4_rtran1 = 1'b1;
        block_wtran2 = 1'b0;//竖着写
        block8_rtran2 = 1'b1;//横着读
        //block4_wtran2 = 1'b0;
        block4_rtran2 = 1'b1;
        tmpStore = mode;
        changeflag <= 0;
        readenable <= 0;
        counter = 0;
        flag <= 0;
        row <= 0;
        col <= 0;
        origin <= 0;
        i <= 0;
        j <= 0;
        for(k1 = 0;k1 < 8;k1 = k1 + 1)
            for(k2 = 0;k2 < 8;k2 = k2 + 1)
            begin
                memory1[k1*8 + k2] <= 0;
                memory2[k1*8 + k2] <= 0;
            end
    end

    always @ (posedge clk)
    begin
        if(enable == 1)
        begin

            if(origin == 0)
            begin
                tmpStore <= mode;
                origin <= 1;
            end

            if(mode == 1)
            begin
                if(flag == 0)
                begin
                    mem1flag <= 1;
                    if(block_wtran1 == 1'b0)
                    begin
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
                                block_wtran2 <= 1'b1;

                            end
                        end
                        if((i == 1) && (col == 6))
                        begin
                            readenable <= 1;
                            readflag <= 0;
                            block8_rtran1 <= 1'b1;
                        end
                    end

                    else
                    begin
                        memory1[i*8 + col] <= data_write;
                        col <= col + 1;
                        if (col == 7)
                        begin
                            col <= 0;
                            i <= i + 1;
                            if (i == 7)
                            begin
                                i <= 0;
                                flag <= 1;
                                modeSave <= mode;
                                block_wtran2 <= 1'b0;

                            end
                        end
                        if((i == 1) && (col == 6))
                        begin
                            readenable <= 1;
                            readflag <= 0;
                            block8_rtran1 <= 1'b0;
                        end
                    end

                end

                else
                begin
                    mem2flag <= 1;
                    if(block_wtran2 == 1'b0)
                    begin
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
                                block_wtran1 <= 1'b1;
                                block8_rtran2 <= 1'b1;
                            end
                        end
                        if((i == 1) && (col == 6))
                        begin
                            readenable <= 1;
                            readflag <= 0;
                        end
                    end

                    else
                    begin
                        memory2[i*8 + col] <= data_write;
                        col <= col + 1;
                        if (col == 7)
                        begin
                            col <= 0;
                            i <= i + 1;
                            if (i == 7)
                            begin
                                i <= 0;
                                flag <= 0;
                                modeSave <= mode;
                                block_wtran1 <= 1'b0;
                            end
                        end
                        if((i == 1) && (col == 6))
                        begin
                            readenable <= 1;
                            readflag <= 0;
                            block8_rtran2 <= 1'b0;
                        end
                    end
                end
            end
            else//4x4
            begin
                if(flag == 0)
                begin
                    mem1flag <= 0;
                    if(block_wtran1 == 1'b0)
                    begin
                        memory1[i*8 + col] <= data_write;
                        i <= i + 1;
                        if (i == 3)
                        begin
                            i <= 0;
                            col <= col + 1;
                            if (col == 3)
                            begin
                                //if(changeflag == 1)
                                flag <= 0;
                                col <= 0;
                                modeSave <= mode;
                                block_wtran1 <= 1'b1;
                                block4_rtran1 <= 1'b1;
                            end
                        end
                    end
                    else
                    begin
                        memory1[i*8 + col] <= data_write;
                        col <= col + 1;
                        if (col == 3)
                        begin
                            col <= 0;
                            i <= i + 1;
                            if (i == 3)
                            begin
                                //if(changeflag == 1)
                                flag <= 0;
                                i <= 0;
                                modeSave <= mode;
                                block_wtran1 <= 1'b0;
                                block4_rtran1 <= 1'b0;
                            end
                        end
                    end
                end
                else
                begin
                    mem2flag <= 0;
                    if(block_wtran2 == 1'b0)
                    begin
                        memory2[i*8 + col] <= data_write;
                        i <= i + 1;
                        if (i == 3)
                        begin
                            i <= 0;
                            col <= col + 1;
                            if (col == 3)
                            begin
                                //if(changeflag == 1)
                                flag <= 0;
                                col <= 0;
                                modeSave <= mode;
                                block_wtran1 <= 1'b1;
                                block4_rtran2 <= 1'b1;
                            end
                        end
                    end
                    else
                    begin
                        memory2[i*8 + col] <= data_write;
                        col <= col + 1;
                        if (col == 3)
                        begin
                            col <= 0;
                            i <= i + 1;
                            if (i == 3)
                            begin
                                //if(changeflag == 1)
                                flag <= 0;
                                i <= 0;
                                modeSave <= mode;
                                block_wtran1 <= 1'b0;
                                block4_rtran2 <= 1'b0;
                            end
                        end
                    end
                end
            end
            //if(modeSave != mode)
                //tmpStore = modeSave;
        end
    end

    always @ (negedge clk)
    begin
        if(readenable == 1)
        begin

            if(tmpStore == 1)
            begin
                //$display("intmpstore");
                if(readflag == 1)
                begin
                    //changeflag <= 0;
                    $display("block1");
                    if(block8_rtran2 == 1'b1)
                    begin
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
                            end
                        end
                    end
                    else
                    begin
                        data_read <= memory2[row *8 + j];
                        row <= row + 1;
                        if (row == 7)
                        begin
                            row <= 0;
                            j <= j + 1;
                            if(j == 7)
                            begin
                                j <= 0;
                                //changeflag <= 1;
                                readflag <= 0;
                            end
                        end
                    end
                end
                else
                begin
                    //$display("inreadflag");
                    //changeflag <= 0;
                    $display("block2");
                    if(block8_rtran1 == 1'b1)
                    begin
                        data_read <= memory1[row *8 + j];
                        j <= j + 1;
                        if (j == 7)
                        begin
                            j <= 0;
                            row <= row + 1;
                            if(row == 7)
                            begin
                                row <= 0;
                                //changeflag <= 1;
                                readflag <= 1;
                                if(mem2flag == 0)
                                    tmpStore <= 0;
                                else if(mem2flag == 1)
                                    tmpStore <= 1;
                            end
                        end
                    end
                    else
                    begin
                        data_read <= memory1[row *8 + j];
                        row <= row + 1;
                        if (row == 7)
                        begin
                            row <= 0;
                            j <= j + 1;
                            if(j == 7)
                            begin
                                j <= 0;
                                //changeflag <= 1;
                                readflag <= 1;
                                if(mem2flag == 0)
                                    tmpStore <= 0;
                                else if(mem2flag == 1)
                                    tmpStore <= 1;
                            end
                        end
                    end
                end
            end
            else
            begin
                if(readflag == 1)
                begin
                    $display("block3");
                    if(block4_rtran2 == 1'b1)
                    begin
                        data_read <= memory2[row*8 + j];
                        j <= j + 1;
                        if (j == 3)
                        begin
                            j <= 0;
                            row <= row + 1;
                            if(row == 3)
                            begin
                                row <= 0;
                                //changeflag <=1;
                                if(mem1flag == 0)
                                    tmpStore <= 0;
                                else if(mem1flag == 1)
                                    tmpStore <= 1;
                            end
                        end
                    end
                    else
                    begin
                        data_read <= memory2[row*8 + j];
                        row <= row + 1;
                        if (row == 3)
                        begin
                            row <= 0;
                            j <= j + 1;
                            if(j == 3)
                            begin
                                j <= 0;
                                //changeflag <=1;
                                if(mem1flag == 0)
                                    tmpStore <= 0;
                                else if(mem1flag == 1)
                                    tmpStore <= 1;
                            end
                        end
                    end
                end
                else
                begin
                    $display("block4");
                    if((j == 3) && (row == 3)&&(counter == 0))
                    begin
                        j = 0;
                        row =0;
                        counter = 1;
                    end
                    if(block4_rtran1 == 1'b1)
                    begin
                        data_read <= memory1[row*8 + j];
                        j <= j + 1;
                        if (j == 3)
                        begin
                            j <= 0;
                            row <= row + 1;
                            if(row == 3)
                            begin
                                row <= 0;
                                //changeflag <=1;
                                if(mem2flag == 0)
                                    tmpStore <= 0;
                                else if(mem2flag == 1)
                                    tmpStore <= 1;
                            end
                        end
                    end
                    else
                    begin
                        data_read <= memory1[row*8 + j];
                        row <= row + 1;
                        if (row == 3)
                        begin
                            row <= 0;
                            j <= j + 1;
                            if(j == 3)
                            begin
                                j <= 0;
                                //changeflag <=1;
                                if(mem2flag == 0)
                                    tmpStore <= 0;
                                else if(mem2flag == 1)
                                    tmpStore <= 1;
                            end
                        end
                    end
                end
            end
        end
    end



endmodule
