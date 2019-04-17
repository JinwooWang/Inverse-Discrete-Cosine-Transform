module read_write_file();
	integer fp_r, fp_w;
	integer count;
    reg clk;
	reg enable;
	wire[15:0] data_read;
	wire tmpmode;
	wire readenable;
    reg[15:0] data_write;
    //reg [95:0]tmp;
    reg mode;
    integer i;
    initial begin
        fp_r=$fopen("data_in2.txt","r");
		fp_w=$fopen("data_out.txt","w");
        i <= 0;
        clk <= 0;
		#10 mode <= 1'd0;
		#50 enable <= 1'd1;
		//#640 mode <= 1'd0;
		//#640 mode <= 1'd0;
		//#640 mode <= 1'd0;
		//#640 mode <= 1'd1;
		//#3560 mode <= 1'd1;
		//#2560 mode <= 1'd0;
		#640 mode <= 1'd0;
		#640 mode <= 1'd0;
		#640 mode <= 1'd0;
		#640 mode <= 1'd1;
		#2560 mode <= 1'd0;
		#640 mode <= 1'd0;
		#640 mode <= 1'd0;
		#640 mode <= 1'd0;
		#640 mode <= 1'd1;

        //#2560 mode <= 1'd0;
		//#3200 mode <= 1'd0;
		//#3840 mode <= 1'd0;
		//#4480 mode <= 1'd0;

		//#5120 mode <= 1'd1;

		//#640 mode <= 1'd0;
		//#640 mode <= 1'd0;
		//#640 mode <= 1'd0;
		//#640 mode <= 1'd0;
		//#640 mode <= 1'd0;
		//#640 mode <= 1'd0;


		//#2560 mode <= 1'd0;
		//#640 mode <= 1'd0;

        /*#20  data_write <= 8'd7;
        #60 data_write <= 8'd12;
        #100 data_write <= 8'd83;
        #140  data_write <= 8'd89;
        #180  data_write <= 8'd75;
        #220 data_write <= 8'd50;
        #260 data_write <= 8'd36;
        #300 data_write <= 8'd83;
        #340  data_write <= 8'd89;
        #380  data_write <= 8'd75;
        #320 data_write <= 8'd50;
        #360 data_write <= 8'd36;
        #400 data_write <= 8'd83;
        #440  data_write <= 8'd89;
        #480  data_write <= 8'd75;
        #420 data_write <= 8'd50;
        #460 data_write <= 8'd36;
        #500 data_write <= 8'd83;*/

    end

	//fp_w=$fopen("data_out.txt","w");
/*    always #40
        begin

                    /*if (i == 0)
                    begin
                        count = $fscanf(fp_r,"%d" ,tmp) ;
                        $display("%d",tmp) ;
                    end
                    else*/
                    //begin



                    //while(i < 20)
                    //begin
					//count = $fscanf(fp_r,"%d" ,data_write) ;
				    //$display("%d",data_write) ;
                    //i = i + 1;
                    //end



                    //end
					//$fwrite(fp_w,"%b\n",reg1) ;

			//$fclose(fp_r);//关闭已打开的文件
			//$fclose(fp_w);
		//end

    always #20 clk = ~clk;//半周期为20ns,全周期为40ns的一个信号
    always@(posedge clk)
    begin
        i <= i + 1;
        //data_write <= i;
		count <= $fscanf(fp_r,"%d" ,data_write) ;
		//$display(data_write);
    end

	always@(negedge clk)
	begin
		//$display(data_read);
		$fwrite(fp_w,"%d\n",data_read) ;
	end

    mem m(data_write, enable, clk, mode, data_read, tmpmode, readenable);
endmodule

//mazm
