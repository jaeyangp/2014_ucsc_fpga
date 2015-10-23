////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: P.20131013
//  \   \         Application: netgen
//  /   /         Filename: oneminute_map.v
// /___/   /\     Timestamp: Mon Feb 17 12:03:56 2014
// \   \  /  \ 
//  \___\/\___\
//             
// Command	: -intstyle ise -s 5 -pcf oneminute.pcf -sdf_anno true -sdf_path netgen/map -insert_glbl true -w -dir netgen/map -ofmt verilog -sim oneminute_map.ncd oneminute_map.v 
// Device	: 3s100ecp132-5 (PRODUCTION 1.27 2013-10-13)
// Input file	: oneminute_map.ncd
// Output file	: D:\FPGA\one_minute\netgen\map\oneminute_map.v
// # of Modules	: 1
// Design Name	: oneminute
// Xilinx        : C:\Xilinx\14.7\ISE_DS\ISE\
//             
// Purpose:    
//     This verilog netlist is a verification model and uses simulation 
//     primitives which may not represent the true implementation of the 
//     device, however the netlist is functionally correct and should not 
//     be modified. This file cannot be synthesized and should only be used 
//     with supported simulation tools.
//             
// Reference:  
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//             
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module oneminute (
  arst, CLK1, an, seg, Led
);
  input arst;
  input CLK1;
  output [3 : 0] an;
  output [0 : 6] seg;
  output [3 : 0] Led;
  wire CLK1_IBUF_52;
  wire arst_IBUF_53;
  wire \Led<3>/O ;
  wire \an<0>/O ;
  wire \an<1>/O ;
  wire \an<2>/O ;
  wire \an<3>/O ;
  wire \CLK1/INBUF ;
  wire \seg<0>/O ;
  wire \seg<1>/O ;
  wire \seg<2>/O ;
  wire \seg<3>/O ;
  wire \seg<4>/O ;
  wire \arst/INBUF ;
  wire \seg<5>/O ;
  wire \seg<6>/O ;
  wire \Led<0>/O ;
  wire \Led<1>/O ;
  wire \Led<2>/O ;
  wire \Led<3>/OUTPUT/OFF/O1INV_62 ;
  wire \an<0>/OUTPUT/OFF/O1INV_70 ;
  wire \an<1>/OUTPUT/OFF/O1INV_78 ;
  wire \an<2>/OUTPUT/OFF/O1INV_86 ;
  wire \an<3>/OUTPUT/OFF/O1INV_94 ;
  wire \seg<0>/OUTPUT/OFF/O1INV_108 ;
  wire \seg<1>/OUTPUT/OFF/O1INV_116 ;
  wire \seg<2>/OUTPUT/OFF/O1INV_124 ;
  wire \seg<3>/OUTPUT/OFF/O1INV_132 ;
  wire \seg<4>/OUTPUT/OFF/O1INV_140 ;
  wire \seg<5>/OUTPUT/OFF/O1INV_154 ;
  wire \seg<6>/OUTPUT/OFF/O1INV_162 ;
  wire \Led<0>/OUTPUT/OFF/O1INV_170 ;
  wire \Led<1>/OUTPUT/OFF/O1INV_178 ;
  wire \Led<2>/OUTPUT/OFF/O1INV_186 ;
  initial $sdf_annotate("netgen/map/oneminute_map.sdf");
  X_OPAD   \Led<3>/PAD  (
    .PAD(Led[3])
  );
  X_OBUF   Led_3_OBUF (
    .I(\Led<3>/O ),
    .O(Led[3])
  );
  X_OPAD   \an<0>/PAD  (
    .PAD(an[0])
  );
  X_OBUF   an_0_OBUF (
    .I(\an<0>/O ),
    .O(an[0])
  );
  X_OPAD   \an<1>/PAD  (
    .PAD(an[1])
  );
  X_OBUF   an_1_OBUF (
    .I(\an<1>/O ),
    .O(an[1])
  );
  X_OPAD   \an<2>/PAD  (
    .PAD(an[2])
  );
  X_OBUF   an_2_OBUF (
    .I(\an<2>/O ),
    .O(an[2])
  );
  X_OPAD   \an<3>/PAD  (
    .PAD(an[3])
  );
  X_OBUF   an_3_OBUF (
    .I(\an<3>/O ),
    .O(an[3])
  );
  X_IPAD   \CLK1/PAD  (
    .PAD(CLK1)
  );
  X_BUF   CLK1_IBUF (
    .I(CLK1),
    .O(\CLK1/INBUF )
  );
  X_OPAD   \seg<0>/PAD  (
    .PAD(seg[0])
  );
  X_OBUF   seg_0_OBUF (
    .I(\seg<0>/O ),
    .O(seg[0])
  );
  X_OPAD   \seg<1>/PAD  (
    .PAD(seg[1])
  );
  X_OBUF   seg_1_OBUF (
    .I(\seg<1>/O ),
    .O(seg[1])
  );
  X_OPAD   \seg<2>/PAD  (
    .PAD(seg[2])
  );
  X_OBUF   seg_2_OBUF (
    .I(\seg<2>/O ),
    .O(seg[2])
  );
  X_OPAD   \seg<3>/PAD  (
    .PAD(seg[3])
  );
  X_OBUF   seg_3_OBUF (
    .I(\seg<3>/O ),
    .O(seg[3])
  );
  X_OPAD   \seg<4>/PAD  (
    .PAD(seg[4])
  );
  X_OBUF   seg_4_OBUF (
    .I(\seg<4>/O ),
    .O(seg[4])
  );
  X_IPAD   \arst/PAD  (
    .PAD(arst)
  );
  X_BUF   arst_IBUF (
    .I(arst),
    .O(\arst/INBUF )
  );
  X_OPAD   \seg<5>/PAD  (
    .PAD(seg[5])
  );
  X_OBUF   seg_5_OBUF (
    .I(\seg<5>/O ),
    .O(seg[5])
  );
  X_OPAD   \seg<6>/PAD  (
    .PAD(seg[6])
  );
  X_OBUF   seg_6_OBUF (
    .I(\seg<6>/O ),
    .O(seg[6])
  );
  X_OPAD   \Led<0>/PAD  (
    .PAD(Led[0])
  );
  X_OBUF   Led_0_OBUF (
    .I(\Led<0>/O ),
    .O(Led[0])
  );
  X_OPAD   \Led<1>/PAD  (
    .PAD(Led[1])
  );
  X_OBUF   Led_1_OBUF (
    .I(\Led<1>/O ),
    .O(Led[1])
  );
  X_OPAD   \Led<2>/PAD  (
    .PAD(Led[2])
  );
  X_OBUF   Led_2_OBUF (
    .I(\Led<2>/O ),
    .O(Led[2])
  );
  X_BUF   \CLK1/IFF/IMUX  (
    .I(\CLK1/INBUF ),
    .O(CLK1_IBUF_52)
  );
  X_BUF   \arst/IFF/IMUX  (
    .I(\arst/INBUF ),
    .O(arst_IBUF_53)
  );
  X_BUF   \Led<3>/OUTPUT/OFF/OMUX  (
    .I(\Led<3>/OUTPUT/OFF/O1INV_62 ),
    .O(\Led<3>/O )
  );
  X_BUF   \Led<3>/OUTPUT/OFF/O1INV  (
    .I(1'b0),
    .O(\Led<3>/OUTPUT/OFF/O1INV_62 )
  );
  X_BUF   \an<0>/OUTPUT/OFF/OMUX  (
    .I(\an<0>/OUTPUT/OFF/O1INV_70 ),
    .O(\an<0>/O )
  );
  X_BUF   \an<0>/OUTPUT/OFF/O1INV  (
    .I(1'b0),
    .O(\an<0>/OUTPUT/OFF/O1INV_70 )
  );
  X_BUF   \an<1>/OUTPUT/OFF/OMUX  (
    .I(\an<1>/OUTPUT/OFF/O1INV_78 ),
    .O(\an<1>/O )
  );
  X_BUF   \an<1>/OUTPUT/OFF/O1INV  (
    .I(1'b0),
    .O(\an<1>/OUTPUT/OFF/O1INV_78 )
  );
  X_BUF   \an<2>/OUTPUT/OFF/OMUX  (
    .I(\an<2>/OUTPUT/OFF/O1INV_86 ),
    .O(\an<2>/O )
  );
  X_BUF   \an<2>/OUTPUT/OFF/O1INV  (
    .I(1'b0),
    .O(\an<2>/OUTPUT/OFF/O1INV_86 )
  );
  X_BUF   \an<3>/OUTPUT/OFF/OMUX  (
    .I(\an<3>/OUTPUT/OFF/O1INV_94 ),
    .O(\an<3>/O )
  );
  X_BUF   \an<3>/OUTPUT/OFF/O1INV  (
    .I(1'b0),
    .O(\an<3>/OUTPUT/OFF/O1INV_94 )
  );
  X_BUF   \seg<0>/OUTPUT/OFF/OMUX  (
    .I(\seg<0>/OUTPUT/OFF/O1INV_108 ),
    .O(\seg<0>/O )
  );
  X_BUF   \seg<0>/OUTPUT/OFF/O1INV  (
    .I(1'b0),
    .O(\seg<0>/OUTPUT/OFF/O1INV_108 )
  );
  X_BUF   \seg<1>/OUTPUT/OFF/OMUX  (
    .I(\seg<1>/OUTPUT/OFF/O1INV_116 ),
    .O(\seg<1>/O )
  );
  X_BUF   \seg<1>/OUTPUT/OFF/O1INV  (
    .I(1'b0),
    .O(\seg<1>/OUTPUT/OFF/O1INV_116 )
  );
  X_BUF   \seg<2>/OUTPUT/OFF/OMUX  (
    .I(\seg<2>/OUTPUT/OFF/O1INV_124 ),
    .O(\seg<2>/O )
  );
  X_BUF   \seg<2>/OUTPUT/OFF/O1INV  (
    .I(1'b0),
    .O(\seg<2>/OUTPUT/OFF/O1INV_124 )
  );
  X_BUF   \seg<3>/OUTPUT/OFF/OMUX  (
    .I(\seg<3>/OUTPUT/OFF/O1INV_132 ),
    .O(\seg<3>/O )
  );
  X_BUF   \seg<3>/OUTPUT/OFF/O1INV  (
    .I(1'b0),
    .O(\seg<3>/OUTPUT/OFF/O1INV_132 )
  );
  X_BUF   \seg<4>/OUTPUT/OFF/OMUX  (
    .I(\seg<4>/OUTPUT/OFF/O1INV_140 ),
    .O(\seg<4>/O )
  );
  X_BUF   \seg<4>/OUTPUT/OFF/O1INV  (
    .I(1'b0),
    .O(\seg<4>/OUTPUT/OFF/O1INV_140 )
  );
  X_BUF   \seg<5>/OUTPUT/OFF/OMUX  (
    .I(\seg<5>/OUTPUT/OFF/O1INV_154 ),
    .O(\seg<5>/O )
  );
  X_BUF   \seg<5>/OUTPUT/OFF/O1INV  (
    .I(1'b0),
    .O(\seg<5>/OUTPUT/OFF/O1INV_154 )
  );
  X_BUF   \seg<6>/OUTPUT/OFF/OMUX  (
    .I(\seg<6>/OUTPUT/OFF/O1INV_162 ),
    .O(\seg<6>/O )
  );
  X_BUF   \seg<6>/OUTPUT/OFF/O1INV  (
    .I(1'b1),
    .O(\seg<6>/OUTPUT/OFF/O1INV_162 )
  );
  X_BUF   \Led<0>/OUTPUT/OFF/OMUX  (
    .I(\Led<0>/OUTPUT/OFF/O1INV_170 ),
    .O(\Led<0>/O )
  );
  X_BUF   \Led<0>/OUTPUT/OFF/O1INV  (
    .I(1'b0),
    .O(\Led<0>/OUTPUT/OFF/O1INV_170 )
  );
  X_BUF   \Led<1>/OUTPUT/OFF/OMUX  (
    .I(\Led<1>/OUTPUT/OFF/O1INV_178 ),
    .O(\Led<1>/O )
  );
  X_BUF   \Led<1>/OUTPUT/OFF/O1INV  (
    .I(1'b0),
    .O(\Led<1>/OUTPUT/OFF/O1INV_178 )
  );
  X_BUF   \Led<2>/OUTPUT/OFF/OMUX  (
    .I(\Led<2>/OUTPUT/OFF/O1INV_186 ),
    .O(\Led<2>/O )
  );
  X_BUF   \Led<2>/OUTPUT/OFF/O1INV  (
    .I(1'b0),
    .O(\Led<2>/OUTPUT/OFF/O1INV_186 )
  );
endmodule


`ifndef GLBL
`define GLBL

`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;

    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule

`endif

