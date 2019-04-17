module memory(
            input reg[15:0] data_write,
            input clk,
            input enable_write,
            input mode,
            output reg[15:0] data_read,
            output enable_read);
    reg modeSave;
    reg readmode;
    reg block8_wtran;
    reg block8_rtran;
    reg block4_wtran;
    reg block4_rtran;
    reg[1:0] block4_locate;
    reg[15:0] mem[0:63];
    reg cond_write;
    integer counter, i, j, row, col, cond;

    initial begin
        counter = 0;
        modeSave = 0;
        row = 0;
        col = 0;
        cond = 0;
        cond_write = 0;
        block4_locate = 2'b00;
        block8_wtran = 1'b0;//竖着写
        block8_rtran = 1'b1;//横着读
        block4_wtran = 1'b0;
        block4_rtran = 1'b1;
    end

    always @ (posedge clk)
    begin
        if (counter == 0)
        begin
            if (mode == 1'b1)
            begin
                mem[i*8 + col] <= data_write;
                i <= i + 1;
                if (i == 8)
                begin
                    i <= 0;
                    col <= col + 1;
                    if ((col == 7) && (i == 2))
                    begin
                        enable_read <= 1;
                        readmode <= 1;
                    end
                    if (col == 8)
                        col <= 0;
                end
                modeSave <= mode;
                block8_wtran <= 1'b1;
            end
            else if (mode == 1'b0)
            begin
                mem[i*4 + col] <= data_write;
                i <= i + 1;
                if (i == 4)
                begin
                    i <= 0;
                    col <= col + 1;
                    if ((col == 3) && (i == 2))
                    begin
                        enable_read <= 1;
                        readmode <= 0;
                    end
                    if (col == 4)
                    begin
                        col <= 0;
                        block4_locate <= 2'b01;
                    end
                end
                modeSave <= mode;
            end
            counter <= counter + 1;
        end
        else
        begin
            if (modeSave == 1'b1)
            begin
                if (mode == 1'b1)
                begin
                    if(block8_wtran == 1'b1)
                    begin
                        mem[i*8 + col] <= data_write;
                        col <= col + 1;
                        if (col == 8)
                        begin
                            col <= 0;
                            i <= i + 1;
                            if ((i == 7) && (col == 2))
                            begin
                                enable_read <= 1;
                                readmode <= 1;
                                block8_rtran <= 1'b0;
                            end
                            if (i == 8)
                                i <= 0;
                        end
                        modeSave <= mode;
                        block8_wtran <= 1'b0;
                    end
                    else if(block8_wtran == 1'b0)
                    begin
                        mem[i*8 + col] <= data_write;
                        i <= i + 1;
                        if (i == 8)
                        begin
                            i <= 0;
                            col <= col + 1;
                            if ((col == 7) && (i == 2))
                            begin
                                enable_read <= 1;
                                readmode <= 1;
                                block8_rtran <= 1'b1;
                            end
                            if (col == 8)
                                col <= 0;
                        end
                        modeSave <= mode;
                        block8_wtran <= 1'b1;
                    end
                end
                else if(mode == 1'b0)
                begin
                    cond <= 1;
                    if (block8_wtran == 1'b1)
                    begin
                        mem[i*4 + col] <= data_write;
                        col <= col + 1;
                        if (col == 4)
                        begin
                            col <= 0;
                            i <= i + 1;
                            if ((i == 3) && (col == 2))
                            begin
                                enable_read <= 1;
                                readmode <= 0;
                                block4_rtran <= 1'b0
                            end
                            if (i == 4)
                            begin
                                i <= 0;
                                block4_locate <= 2'b01;
                            end
                        end
                        modeSave <= mode;
                    end
                    else if(block8_wtran == 1'b0)
                    begin
                        mem[i*4 + col] <= data_write;
                        i <= i + 1;
                        if (i == 4)
                        begin
                            i <= 0;
                            col <= col + 1;
                            if ((col == 3) && (i == 2))
                            begin
                                enable_read <= 1;
                                readmode <= 0;
                                block4_rtran <= 1'b1
                            end
                            if (col == 4)
                            begin
                                col <= 0;
                                block4_locate <= 2'b01;
                            end
                        end
                        modeSave <= mode;
                    end
                end
            end

            if (modeSave == 1'b0)
            begin
                if (mode == 1'b1)
                begin
                    if (cond == 1)
                    begin
                        if(block4_wtran == 1'b1)
                        begin
                            if (cond_write == 1'b1)
                            begin
                                mem[i*8 + col] <= data_write;
                                col <= col + 1;
                                if (col == 8)
                                begin
                                    col <= 0;
                                    i <= i + 1;
                                    if ((i == 7) && (col == 2))
                                    begin
                                        enable_read <= 1;
                                        readmode <= 1;
                                        block8_rtran <= 1'b0;
                                    end
                                    if (i == 8)
                                        i <= 0;
                                end
                                modeSave <= mode;
                                block8_wtran <= 1'b0;
                            end
                        end
                        else
                        begin
                            if (cond_write == 1'b1)
                            begin
                                mem[i*8 + col] <= data_write;
                                i <= i + 1;
                                if (i == 8)
                                begin
                                    i <= 0;
                                    col <= col + 1;
                                    if ((col == 7) && (i == 2))
                                    begin
                                        enable_read <= 1;
                                        readmode <= 1;
                                        block8_rtran <= 1'b1;
                                    end
                                    if (col == 8)
                                        col <= 0;
                                end
                                modeSave <= mode;
                                block8_wtran <= 1'b1;
                            end
                        end
                    end

                    else
                    begin
                        if(block4_wtran == 1'b1)
                        begin
                            mem[i*8 + col] <= data_write;
                            col <= col + 1;
                            if (col == 8)
                            begin
                                col <= 0;
                                i <= i + 1;
                                if ((i == 7) && (col == 2))
                                begin
                                    enable_read <= 1;
                                    readmode <= 1;
                                    block8_rtran <= 1'b0;
                                end
                                if (i == 8)
                                    i <= 0;
                            end
                            modeSave <= mode;
                            block8_wtran <= 1'b0;
                        end
                        else
                        begin
                            mem[i*8 + col] <= data_write;
                            i <= i + 1;
                            if (i == 8)
                            begin
                                i <= 0;
                                col <= col + 1;
                                if ((col == 7) && (i == 2))
                                begin
                                    enable_read <= 1;
                                    readmode <= 1;
                                    block8_rtran <= 1'b1;
                                end
                                if (col == 8)
                                    col <= 0;
                            end
                            modeSave <= mode;
                            block8_wtran <= 1'b1;
                        end
                    end

                end

                else
                begin
                    if (block4_wtran == 1'b0)
                    begin
                        if(block4_locate == 2'b00)
                        begin
                            col = 0;
                            i = 0;
                            mem[i*4 + col] <= data_write;
                            i <= i + 1;
                            if (i == 4)
                            begin
                                i <= 0;
                                col <= col + 1;
                                if ((col == 3) && (i == 2))
                                begin
                                    enable_read <= 1;
                                    readmode <= 0;
                                end
                                if (col == 4)
                                begin
                                    col <= 0;
                                    block4_locate <= 2'b01;
                                end
                            end
                            modeSave <= mode;
                        end
                        else if(block4_locate == 2'b01)
                        begin
                            col = 4;
                            i = 0;
                            mem[i*4 + col] <= data_write;
                            i <= i + 1;
                            if (i == 4)
                            begin
                                i <= 0;
                                col <= col + 1;
                                if ((col == 7) && (i == 2))
                                begin
                                    enable_read <= 1;
                                    readmode <= 0;
                                end
                                if (col == 8)
                                begin
                                    col <= 4;
                                    block4_locate <= 2'b10;
                                end
                            end
                            modeSave <= mode;
                        end
                        else if(block4_locate == 2'b10)
                        begin
                            i = 4;
                            col = 0;
                            mem[i*4 + col] <= data_write;
                            i <= i + 1;
                            if (i == 8)
                            begin
                                i <= 4;
                                col <= col + 1;
                                if ((col == 3) && (i == 6))
                                begin
                                    enable_read <= 1;
                                    readmode <= 0;
                                end
                                if (col == 4)
                                begin
                                    col <= 0;
                                    block4_locate <= 2'b11;
                                end
                            end
                            modeSave <= mode;
                        end
                        else if(block4_locate == 2'b11)
                        begin
                            i = 4;
                            col = 4;
                            mem[i*4 + col] <= data_write;
                            i <= i + 1;
                            if (i == 8)
                            begin
                                i <= 4;
                                col <= col + 1;
                                if ((col == 7) && (i == 6))
                                begin
                                    enable_read <= 1;
                                    readmode <= 0;
                                end
                                if (col == 8)
                                begin
                                    col <= 4;
                                    block4_locate <= 2'b00;
                                end
                            end
                            modeSave <= mode;
                        end
                    end
                end
            end
        end
    end

    always@(negedge clk)
    begin
        if (enable_read)
        begin
            if (readmode == 1'b1)
            begin
                if (cond == 1)
                begin

                end
                else
                begin
                    if (block8_rtran == 1'b1)
                    begin
                        data_read <= mem[row *8 + j];
                        j <= j + 1;
                        if (j == 8)
                        begin
                            j <= 0;
                            row <= row + 1;
                            if(row == 8)
                                row <= 0;
                        end
                    end
                    else
                    begin
                        data_read <= mem[row *8 + j];
                        row <= row + 1;
                        if (row == 8)
                        begin
                            rwo <= 0;
                            j <= j + 1;
                            if(j == 8)
                                j <= 0;
                        end
                    end
                end
            end
            else if (readmode == 1'b0)
            begin
                data_read <= mem[row *4 + j];
                j <= j + 1;
                if (j == 4)
                begin
                    j <= 0;
                    row <= row + 1;
                    if(row == 4)
                        row <= 0;
                end
            end
        end

    end

endmodule
