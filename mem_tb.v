`timescale 1ns/1ps

module mem_tb;

reg clk;
reg rst;

reg signed [15: 0] Data[0: 63];


initial
begin
	clk = 0;
	rst = 1;
	#0.25 rst = 0;
	#0.5  rst = 1;
end

always # 1 clk = ~clk;


integer fidr, fidw;
integer i, j;
reg[8*9 - 1:0] mode_4str;
reg[8*9 - 1:0] mode_8str;
reg[8*9 - 1:0] mode_read;

reg  mode_4_8_tmp;
reg  mode_4_8;

wire  mode_out;
reg enable_i;
wire enable_o;

reg [5:0] input_index;
reg signed [15:0] x;
wire signed [15:0] y;

initial
begin
	mode_4str = "mode = 00";
	mode_8str = "mode = 01";
	fidr = $fopen("D:\\DE\\input0.txt", "r");
	fidw = $fopen("D:\\DE\\output.txt", "w");
	$fgets(mode_read, fidr);
	//$display("%s is stored as %h",mode_read,mode_read);
	if(mode_read == mode_4str)
	begin
		mode_4_8_tmp <= 0;
		for(i = 0; i < 16; i = i + 1)
			$fscanf(fidr, "%d", Data[i]);
	end

	if(mode_read == mode_8str)
	begin
		mode_4_8_tmp <= 1;
		for(i = 0; i < 64; i = i + 1)
			$fscanf(fidr, "%d", Data[i]);
	end
	$fgets(mode_read, fidr);
end

reg [5:0] output_cnt;
reg stop_ack;
reg [4:0] stop_cnt;

always @(posedge clk or negedge rst)
begin
	if(rst == 0)
		output_cnt <= 0;
	else
	begin
		if(enable_o)
		begin
			if(mode_out == 0)
			begin
				if(output_cnt == 15)
					output_cnt <= 0;
				else
					output_cnt <= output_cnt + 1;
			end
			else
				output_cnt <= output_cnt + 1;
		end
	end
end

always @(posedge clk)
begin
	if(enable_o == 1)
	begin
		if(output_cnt == 0 && mode_out == 0)
			$fwrite(fidw, "mode = 00\n");
		if(output_cnt == 0 && mode_out == 1)
			$fwrite(fidw, "mode = 01\n");
		$fwrite(fidw, "%d\n", y);
	end
end


always @(posedge clk or negedge rst)
begin
	if(rst == 0)
		enable_i <= 0;
	else
	begin
		if(stop_cnt != 10)
			enable_i <= 1;
		else
			enable_i <= 0;
	end
end


always @(posedge clk or negedge rst)
begin
	if(rst == 0)
		input_index <= 0;
	else
	begin
		if(mode_4_8_tmp == 0)
		begin
			if(input_index == 15)
				input_index <= 0;
			else
				input_index <= input_index + 1;
		end
		else
			input_index <= input_index + 1;
	end
end

always @(posedge clk)
begin
	if(mode_4_8_tmp == 0 && input_index == 15)
	begin
		$fgets(mode_read, fidr);
		if(mode_read != 72'b0)
		begin
			if(mode_read == mode_4str)
			begin
				mode_4_8_tmp <= 0;
				for(i = 0; i < 16; i = i + 1)
					$fscanf(fidr, "%d", Data[i]);
			end

			if(mode_read == mode_8str)
			begin
				mode_4_8_tmp <= 1;
				for(i = 0; i < 64; i = i + 1)
					$fscanf(fidr, "%d", Data[i]);
			end
			$fgets(mode_read, fidr);
		end
		else
		begin
			stop_ack = 1;
			for(i = 0; i < 64; i = i + 1)
				Data[i] = 0;
		end
	end

	if(mode_4_8_tmp == 1 && input_index == 63)
	begin
		$fgets(mode_read, fidr);
		if(mode_read != 72'b0)
		begin
			if(mode_read == mode_4str)
			begin
				mode_4_8_tmp <= 0;
				for(i = 0; i < 16; i = i + 1)
					$fscanf(fidr, "%d", Data[i]);
			end

			if(mode_read == mode_8str)
			begin
				mode_4_8_tmp <= 1;
				for(i = 0; i < 64; i = i + 1)
					$fscanf(fidr, "%d", Data[i]);
			end
			$fgets(mode_read, fidr);
		end
		else
		begin
			stop_ack = 1;
			for(i = 0; i < 64; i = i + 1)
				Data[i] = 0;
		end
	end
end

always @(negedge rst)
begin
	if(rst == 0)
		stop_ack <= 0;
end

always @(posedge clk or negedge rst)
begin
	if(rst == 0)
		stop_cnt <= 0;
	else
	begin
		if(stop_ack == 1)
		begin
			if(stop_cnt != 10)
				stop_cnt <= stop_cnt + 1;
		end
	end
end

always @(posedge clk)
begin
	mode_4_8 <= mode_4_8_tmp;
end

always @(posedge clk or negedge rst)
begin
	if(rst == 0)
		x <= 0;
	else
		x <= Data[input_index];
end

wire [15:0] y_tmp;
wire [15:0] x_tmp;
wire enable_tmp;
wire mode_tmp;
wire enable_tmp2;
wire mode_tmp2;


/*
col_conversion col_conversion_i(.clk_in(clk),
								.rst_in(rst),
								.enable_i(enable_i),
								.x(x),
								.mode_4_8(mode_4_8),
								.y(y_tmp),
								.mode_out(mode_tmp),
								.enable_o(enable_tmp));
*/
mem mem_i(.data_write(x),
		  .enable(enable_i),
		  .reset(rst),
		  .clk(clk),
		  .mode(mode_4_8),
		  .data_read(y),
		  .outmode(mode_out),
		  .readenable(enable_o));

		  /*
row_conversion row_conversion_i(.clk_in(clk),
								.rst_in(rst),
								.enable_i(enable_tmp2),
								.x(x_tmp),
								.mode_4_8(mode_tmp2),
								.y(y),
								.mode_out(mode_out),
								.enable_o(enable_o));

*/
endmodule
