   
`timescale 1 ns / 1 ps

	module axi_dma_wr_v1_0_M00_AXI #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Base address of targeted slave
		parameter  C_M_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
		// Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
		parameter integer C_M_AXI_BURST_LEN	= 16,
		// Thread ID Width
		parameter integer C_M_AXI_ID_WIDTH	= 1,
		// Width of Address Bus
		parameter integer C_M_AXI_ADDR_WIDTH	= 32,
		// Width of Data Bus
		parameter integer C_M_AXI_DATA_WIDTH	= 32,
		// Width of User Write Address Bus
		parameter integer C_M_AXI_AWUSER_WIDTH	= 0,
		// Width of User Read Address Bus
		parameter integer C_M_AXI_ARUSER_WIDTH	= 0,
		// Width of User Write Data Bus
		parameter integer C_M_AXI_WUSER_WIDTH	= 0,
		// Width of User Read Data Bus
		parameter integer C_M_AXI_RUSER_WIDTH	= 0,
		// Width of User Response Bus
		parameter integer C_M_AXI_BUSER_WIDTH	= 0
	)
	(
		// Users to add ports here
		input	wire 		data_clk,
		input	wire 		ap_rst_n,
		input	wire 		dma_wr_dsin, //写fifo的使能
		input	wire [15:0] dma_wr_din, //写fifo的数据
		input 	wire [31:0] end_addrb,

		// User ports ends
		// Do not modify the ports beyond this line

		// Initiate AXI transactions
		input wire  INIT_AXI_TXN,
		// Asserts when transaction is complete
		output wire  TXN_DONE,
		// Asserts when ERROR is detected
		output reg  ERROR,
		// Global Clock Signal.
		input wire  M_AXI_ACLK,
		// Global Reset Singal. This Signal is Active Low
		input wire  M_AXI_ARESETN,
		// Master Interface Write Address ID
		output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID,
		// Master Interface Write Address
		output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		output wire [7 : 0] M_AXI_AWLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		output wire [2 : 0] M_AXI_AWSIZE,
		// Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
		output wire [1 : 0] M_AXI_AWBURST,
		// Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
		output wire  M_AXI_AWLOCK,
		// Memory type. This signal indicates how transactions
    // are required to progress through a system.
		output wire [3 : 0] M_AXI_AWCACHE,
		// Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
		output wire [2 : 0] M_AXI_AWPROT,
		// Quality of Service, QoS identifier sent for each write transaction.
		output wire [3 : 0] M_AXI_AWQOS,
		// Optional User-defined signal in the write address channel.
		output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER,
		// Write address valid. This signal indicates that
    // the channel is signaling valid write address and control information.
		output wire  M_AXI_AWVALID,
		// Write address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
		input wire  M_AXI_AWREADY,
		// Master Interface Write Data.
		output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,
		// Write strobes. This signal indicates which byte
    // lanes hold valid data. There is one write strobe
    // bit for each eight bits of the write data bus.
		output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB,
		// Write last. This signal indicates the last transfer in a write burst.
		output wire  M_AXI_WLAST,
		// Optional User-defined signal in the write data channel.
		output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER,
		// Write valid. This signal indicates that valid write
    // data and strobes are available
		output wire  M_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    // can accept the write data.
		input wire  M_AXI_WREADY,
		// Master Interface Write Response.
		input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID,
		// Write response. This signal indicates the status of the write transaction.
		input wire [1 : 0] M_AXI_BRESP,
		// Optional User-defined signal in the write response channel
		input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER,
		// Write response valid. This signal indicates that the
    // channel is signaling a valid write response.
		input wire  M_AXI_BVALID,
		// Response ready. This signal indicates that the master
    // can accept a write response.
		output wire  M_AXI_BREADY,
		// Master Interface Read Address.
		output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID,
		// Read address. This signal indicates the initial
    // address of a read burst transaction.
		output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		output wire [7 : 0] M_AXI_ARLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		output wire [2 : 0] M_AXI_ARSIZE,
		// Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
		output wire [1 : 0] M_AXI_ARBURST,
		// Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
		output wire  M_AXI_ARLOCK,
		// Memory type. This signal indicates how transactions
    // are required to progress through a system.
		output wire [3 : 0] M_AXI_ARCACHE,
		// Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
		output wire [2 : 0] M_AXI_ARPROT,
		// Quality of Service, QoS identifier sent for each read transaction
		output wire [3 : 0] M_AXI_ARQOS,
		// Optional User-defined signal in the read address channel.
		output wire [C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER,
		// Write address valid. This signal indicates that
    // the channel is signaling valid read address and control information
		output wire  M_AXI_ARVALID,
		// Read address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
		input wire  M_AXI_ARREADY,
		// Read ID tag. This signal is the identification tag
    // for the read data group of signals generated by the slave.
		input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID,
		// Master Read Data
		input wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
		// Read response. This signal indicates the status of the read transfer
		input wire [1 : 0] M_AXI_RRESP,
		// Read last. This signal indicates the last transfer in a read burst
		input wire  M_AXI_RLAST,
		// Optional User-defined signal in the read address channel.
		input wire [C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER,
		// Read valid. This signal indicates that the channel
    // is signaling the required read data.
		input wire  M_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    // accept the read data and response information.
		output wire  M_AXI_RREADY
	);


	// function called clogb2 that returns an integer which has the
	//value of the ceiling of the log base 2

	  // function called clogb2 that returns an integer which has the 
	  // value of the ceiling of the log base 2.                      
	  function integer clogb2 (input integer bit_depth);              
	  begin                                                           
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
	      bit_depth = bit_depth >> 1;                                 
	    end                                                           
	  endfunction                                                     

	// C_TRANSACTIONS_NUM is the width of the index counter for 
	// number of write or read transaction.
	 localparam integer C_TRANSACTIONS_NUM = clogb2(C_M_AXI_BURST_LEN-1);

	// Burst length for transactions, in C_M_AXI_DATA_WIDTHs.
	// Non-2^n lengths will eventually cause bursts across 4K address boundaries.
	 localparam integer C_MASTER_LENGTH	= 12;
	// total number of burst transfers is master length divided by burst length and burst size
	 localparam integer C_NO_BURSTS_REQ = C_MASTER_LENGTH-clogb2((C_M_AXI_BURST_LEN*C_M_AXI_DATA_WIDTH/8)-1);
	// Example State machine to initialize counter, initialize write transactions, 
	// initialize read transactions and comparison of read data with the 
	// written data words.
	parameter [1:0] IDLE = 2'b00, // This state initiates AXI4Lite transaction 
			// after the state machine changes state to INIT_WRITE 
			// when there is 0 to 1 transition on INIT_AXI_TXN
		INIT_WRITE   = 2'b01, // This state initializes write transaction,
			// once writes are done, the state machine 
			// changes state to INIT_READ 
		INIT_READ = 2'b10, // This state initializes read transaction
			// once reads are done, the state machine 
			// changes state to INIT_COMPARE 
		INIT_COMPARE = 2'b11; // This state issues the status of comparison 
			// of the written data with the read data	

	 reg [1:0] mst_exec_state;

	// AXI4LITE signals
	//AXI4 internal temp signals
	reg [C_M_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awvalid;
	reg [C_M_AXI_DATA_WIDTH-1 : 0] 	axi_wdata;
	reg  	axi_wlast;
	reg  	axi_wvalid;
	reg  	axi_bready;
	reg [C_M_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arvalid;
	reg  	axi_rready;
	//write beat count in a burst
	reg [C_TRANSACTIONS_NUM : 0] 	write_index;
	//read beat count in a burst
	reg [C_TRANSACTIONS_NUM : 0] 	read_index;
	//size of C_M_AXI_BURST_LEN length burst in bytes
	wire [C_TRANSACTIONS_NUM+2 : 0] 	burst_size_bytes;
	//The burst counters are used to track the number of burst transfers of C_M_AXI_BURST_LEN burst length needed to transfer 2^C_MASTER_LENGTH bytes of data.
	reg [C_NO_BURSTS_REQ : 0] 	write_burst_counter;
	reg [C_NO_BURSTS_REQ : 0] 	read_burst_counter;
	reg  	start_single_burst_write;
	reg  	start_single_burst_read;
	reg  	writes_done;
	reg  	reads_done;
	reg  	error_reg;
	reg  	compare_done;
	reg  	read_mismatch;
	reg  	burst_write_active;
	reg  	burst_read_active;
	reg [C_M_AXI_DATA_WIDTH-1 : 0] 	expected_rdata;
	//Interface response error flags
	wire  	write_resp_error;
	wire  	read_resp_error;
	wire  	wnext;
	wire  	rnext;
	reg  	init_txn_ff;
	reg  	init_txn_ff2;
	reg  	init_txn_edge;
	wire  	init_txn_pulse;


	wire  	wr_fifo_en;
	wire    [15:0] wr_fifo_data;
	wire 	[9:0]	rd_data_count;
	reg 	burst_start;
	reg      wr_flag =1;
	reg [7:0] burst_cnt;
	wire 	rd_fifo_en;
	wire [63:0]	rd_fifo_data;
	reg [5:0] cnt_done;

	// I/O Connections assignments

	//I/O Connections. Write Address (AW)
	assign M_AXI_AWID	= 'b0;
	//The AXI address is a concatenation of the target base address + active offset range
	assign M_AXI_AWADDR	= C_M_TARGET_SLAVE_BASE_ADDR + axi_awaddr;
	//Burst LENgth is number of transaction beats, minus 1
	assign M_AXI_AWLEN	= C_M_AXI_BURST_LEN - 1;
	//Size should be C_M_AXI_DATA_WIDTH, in 2^SIZE bytes, otherwise narrow bursts are used
	assign M_AXI_AWSIZE	= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
	//INCR burst type is usually used, except for keyhole bursts
	assign M_AXI_AWBURST	= 2'b01;
	assign M_AXI_AWLOCK	= 1'b0;
	//Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable. Not Bufferable since this example is meant to test memory, not intermediate cache. 
	assign M_AXI_AWCACHE	= 4'b0010;
	assign M_AXI_AWPROT	= 3'h0;
	assign M_AXI_AWQOS	= 4'h0;
	assign M_AXI_AWUSER	= 'b1;
	assign M_AXI_AWVALID	= axi_awvalid;
	//Write Data(W)
	assign M_AXI_WDATA	= axi_wdata;
	//All bursts are complete and aligned in this example
	assign M_AXI_WSTRB	= {(C_M_AXI_DATA_WIDTH/8){1'b1}};
	assign M_AXI_WLAST	= axi_wlast;
	assign M_AXI_WUSER	= 'b0;
	assign M_AXI_WVALID	= axi_wvalid;
	//Write Response (B)
	assign M_AXI_BREADY	= axi_bready;
	//Read Address (AR)
	assign M_AXI_ARID	= 'b0;
	assign M_AXI_ARADDR	= C_M_TARGET_SLAVE_BASE_ADDR + axi_araddr;
	//Burst LENgth is number of transaction beats, minus 1
	assign M_AXI_ARLEN	= C_M_AXI_BURST_LEN - 1;
	//Size should be C_M_AXI_DATA_WIDTH, in 2^n bytes, otherwise narrow bursts are used
	assign M_AXI_ARSIZE	= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
	//INCR burst type is usually used, except for keyhole bursts
	assign M_AXI_ARBURST	= 2'b01;
	assign M_AXI_ARLOCK	= 1'b0;
	//Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable. Not Bufferable since this example is meant to test memory, not intermediate cache. 
	assign M_AXI_ARCACHE	= 4'b0010;
	assign M_AXI_ARPROT	= 3'h0;
	assign M_AXI_ARQOS	= 4'h0;
	assign M_AXI_ARUSER	= 'b1;
	assign M_AXI_ARVALID	= axi_arvalid;
	//Read and Read Response (R)
	assign M_AXI_RREADY	= axi_rready;
	//Example design I/O
	assign TXN_DONE	= compare_done;
	//Burst size in bytes
	assign burst_size_bytes	= C_M_AXI_BURST_LEN * C_M_AXI_DATA_WIDTH/8;
	assign init_txn_pulse	= (!init_txn_ff2) && init_txn_ff;


	//Generate a pulse to initiate AXI transaction.
	always @(posedge M_AXI_ACLK)										      
	  begin                                                                        
	    // Initiates AXI transaction delay    
	    if (M_AXI_ARESETN == 0 )                                                   
	      begin                                                                    
	        init_txn_ff <= 1'b0;                                                   
	        init_txn_ff2 <= 1'b0;                                                   
	      end                                                                               
	    else                                                                       
	      begin  
	        init_txn_ff <= INIT_AXI_TXN;
	        init_txn_ff2 <= init_txn_ff;                                                                 
	      end                                                                      
	  end     


	//--------------------
	//Write Address Channel
	//--------------------
	assign wr_fifo_en = dma_wr_dsin;
	assign wr_fifo_data = dma_wr_din;
	asfifo_w16x2048_r64x256 dma_wr_data_buf (
	  .wr_clk(data_clk),                // input wire wr_clk
	  .rd_clk(M_AXI_ACLK),                // input wire rd_clk
	  .din(wr_fifo_data),                      // input wire [15 : 0] din
	  .wr_en(wr_fifo_en),                  // input wire wr_en
	  .rd_en(rd_fifo_en),                  // input wire rd_en
	  .dout(rd_fifo_data),                    // output wire [63 : 0] dout
	  .full(full),                    // output wire full
	  .empty(empty),                  // output wire empty
	  .rd_data_count(rd_data_count)  // output wire [9 : 0] rd_data_count
	);

	always@(posedge M_AXI_ACLK)begin
		if(M_AXI_ARESETN == 1'b0)begin
			wr_flag <= 1'b1;
		end
		else if(axi_wlast== 1'b1 &&  axi_awaddr == 'd0)begin  //疑问：为啥要加上axi_awaddr?难道这两个条件不是同时满足的吗？最大地址endaddrb怎么给的？
			wr_flag <= 1'b0;
		end
	end

	always@(posedge M_AXI_ACLK)begin
		if(M_AXI_ARESETN ==1'b0)begin
			burst_start <= 1'b0;
		end
		else if (wr_flag == 1'b1 && rd_data_count >= 'd256 && axi_awvalid == 1'b0 && axi_wvalid == 1'b0)begin//fifo里面至少有256个64位的数，才说明pl段准备好了一整个突发长度的数据，以便于DMA写通道开始工作
			burst_start <= 1'b1;
		end
		else begin
			burst_start <= 1'b0;
		end			
	end

	always@(posedge M_AXI_ACLK)begin
		if (M_AXI_ARESETN == 1'b0)begin
			axi_awvalid <= 1'b0;
		end
		else if (axi_awvalid == 1'b1 && M_AXI_AWREADY == 1'b1)begin  //一定要等写地址有效和写地址ready同时为1之后，写地址有效才能拉低！不然无法建立握手
			axi_awvalid <= 1'b0;
		end
		else if(burst_start == 1'b1)begin
			axi_awvalid <= 1'b1;
		end
	end

	//控制地址递增部分
	always @(posedge M_AXI_ACLK)begin
		if (M_AXI_ARESETN)begin
			axi_awaddr<= 'd0;
		end
		else if (axi_awvalid == 1'b1 && M_AXI_AWREADY == 1'b1 && axi_awaddr == end_addrb-2048)begin  //axi_awaddr == end_addrb-2048时，并不能算结束，而是当
			axi_awaddr <= 'd0;																		//axi_awaddr == end_addrb-2048且axi_awaddr又满足增加一组突发长度的
		end 																						//条件时（即axi_awvalid == 1'b1 && M_AXI_AWREADY == 1'b1）才清零
		else if (axi_awvalid == 1'b1 && M_AXI_AWREADY == 1'b1)begin
			axi_awaddr<= axi_awaddr + 2048;
		end
	end
	//控制部分结束
	always@(posedge M_AXI_ACLK)begin
		if(M_AXI_AWREADY == 1'b0)begin
			axi_wvalid <= 'd0;
		end
		else if(axi_wvalid == 1'b1 && M_AXI_WREADY == 1'b1 && burst_cnt == 255)begin //写有效是一直拉高的，写ready由外部输入，即M_AXI_WREADY
			axi_wvalid <= 'd0;
		end
		else if(axi_awvalid == 1'b1 && M_AXI_AWREADY == 1'b1)begin
			axi_wvalid <= 1'b1;
		end
	end

	always@(posedge M_AXI_ACLK)begin
		if(M_AXI_AWREADY == 1'b0)begin
			burst_cnt <= 'd0;
		end
		else if(axi_wvalid == 1'b1 && M_AXI_WREADY == 1'b1 && burst_cnt == 255)begin  //写满256个64位的数就拉低写有效，下一次写有效拉高需要写地址有效和准备好再握手
			burst_cnt <= 'd0;
		end
		else if(axi_wvalid == 1'b1 && M_AXI_WREADY == 1'b1)begin
			burst_cnt <= burst_cnt + 1'b1;
		end
	end

	always @* begin
		if(axi_wvalid == 1'b1 && M_AXI_WREADY == 1'b1 && burst_cnt == 255)begin
			axi_wlast <= 1'b1;
		end
		else begin
			axi_wlast<= 1'b0;
		end
	end

	assign rd_fifo_en = axi_wvalid & M_AXI_WREADY;//一旦外部输入的写ready有效且写valid有效，那么就读出一个数

	//但是还有一个问题，先写进去的16位，会在fifo读出64位时变成高16位。到时候放在SD卡里面也就成了高16位，所以这里需要做一次翻转
	always@* begin
		axi_wdata <= {rd_fifo_data[15:0],rd_fifo_data[31:16],rd_fifo_data[47:32],rd_fifo_data[63:48]};//实际写入ddr里面时，这里的靠右到时候地址越低
	end

	always@(posedge M_AXI_ACLK) begin
		if(M_AXI_ARESETN == 1'b1)begin
			axi_bready <= 1'b0;
		end
		else begin
			axi_bready <= 1'b1;
		end
	end

	//下面是为了产生一个16个clk的脉冲告诉ps的一侧取数完毕
	always @(posedge M_AXI_ACLK)begin
		if(M_AXI_ARESETN == 1'b0)begin
			compare_done <= 1'b0; 
		end
		else if(cnt_done == 'd15)begin
			compare_done <= 1'b0;
		end
		else if (axi_wlast== 1'b1 &&  axi_awaddr == 'd0)begin
			compare_done <= 1'b1;
		end
	end

	always@( posedge M_AXI_ACLK)begin
		if(M_AXI_ARESETN==1'b1)begin
			cnt_done <= 'd0;
		end
		else if(compare_done == 1'b1)begin
			cnt_done <= cnt_done +1'b1;
		end
		else begin
			cnt_done <= 'd0;
		end
	end
	// Add user logic here

	// User logic ends

	endmodule
