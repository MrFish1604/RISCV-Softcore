-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- *****************************************************************************
-- This file contains a Vhdl test bench with test vectors .The test vectors     
-- are exported from a vector file in the Quartus Waveform Editor and apply to  
-- the top level entity of the current Quartus project .The user can use this   
-- testbench to simulate his design using a third-party simulation tool .       
-- *****************************************************************************
-- Generated on "10/02/2024 11:05:21"
                                                             
-- Vhdl Test Bench(with test vectors) for design  :          single_port_rom
-- 
-- Simulation tool : 3rd Party
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY single_port_rom_vhd_vec_tst IS
END single_port_rom_vhd_vec_tst;
ARCHITECTURE single_port_rom_arch OF single_port_rom_vhd_vec_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL addr : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL clk : STD_LOGIC;
SIGNAL q : STD_LOGIC_VECTOR(7 DOWNTO 0);
COMPONENT single_port_rom
	PORT (
	addr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	clk : IN STD_LOGIC;
	q : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : single_port_rom
	PORT MAP (
-- list connections between master ports and signals
	addr => addr,
	clk => clk,
	q => q
	);

-- clk
t_prcs_clk: PROCESS
BEGIN
LOOP
	clk <= '0';
	WAIT FOR 10000 ps;
	clk <= '1';
	WAIT FOR 10000 ps;
	IF (NOW >= 1000000 ps) THEN WAIT; END IF;
END LOOP;
END PROCESS t_prcs_clk;
-- addr[7]
t_prcs_addr_7: PROCESS
BEGIN
	addr(7) <= '0';
WAIT;
END PROCESS t_prcs_addr_7;
-- addr[6]
t_prcs_addr_6: PROCESS
BEGIN
	addr(6) <= '0';
WAIT;
END PROCESS t_prcs_addr_6;
-- addr[5]
t_prcs_addr_5: PROCESS
BEGIN
	addr(5) <= '0';
	WAIT FOR 736000 ps;
	addr(5) <= '1';
WAIT;
END PROCESS t_prcs_addr_5;
-- addr[4]
t_prcs_addr_4: PROCESS
BEGIN
	addr(4) <= '0';
	WAIT FOR 368000 ps;
	addr(4) <= '1';
	WAIT FOR 368000 ps;
	addr(4) <= '0';
WAIT;
END PROCESS t_prcs_addr_4;
-- addr[3]
t_prcs_addr_3: PROCESS
BEGIN
	FOR i IN 1 TO 2
	LOOP
		addr(3) <= '0';
		WAIT FOR 184000 ps;
		addr(3) <= '1';
		WAIT FOR 184000 ps;
	END LOOP;
	addr(3) <= '0';
	WAIT FOR 184000 ps;
	addr(3) <= '1';
WAIT;
END PROCESS t_prcs_addr_3;
-- addr[2]
t_prcs_addr_2: PROCESS
BEGIN
	FOR i IN 1 TO 5
	LOOP
		addr(2) <= '0';
		WAIT FOR 92000 ps;
		addr(2) <= '1';
		WAIT FOR 92000 ps;
	END LOOP;
	addr(2) <= '0';
WAIT;
END PROCESS t_prcs_addr_2;
-- addr[1]
t_prcs_addr_1: PROCESS
BEGIN
	FOR i IN 1 TO 10
	LOOP
		addr(1) <= '0';
		WAIT FOR 46000 ps;
		addr(1) <= '1';
		WAIT FOR 46000 ps;
	END LOOP;
	addr(1) <= '0';
	WAIT FOR 46000 ps;
	addr(1) <= '1';
WAIT;
END PROCESS t_prcs_addr_1;
-- addr[0]
t_prcs_addr_0: PROCESS
BEGIN
	FOR i IN 1 TO 21
	LOOP
		addr(0) <= '0';
		WAIT FOR 23000 ps;
		addr(0) <= '1';
		WAIT FOR 23000 ps;
	END LOOP;
	addr(0) <= '0';
	WAIT FOR 23000 ps;
	addr(0) <= '1';
WAIT;
END PROCESS t_prcs_addr_0;
END single_port_rom_arch;
