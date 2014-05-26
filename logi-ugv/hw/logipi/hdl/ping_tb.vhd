--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:32:21 05/24/2014
-- Design Name:   
-- Module Name:   E:/Dropbox/Prj/Valent/LOGI-FAMILY/1logi-github/private/Logi-projects/logi-ping/hw/ise/ping_tb.vhd
-- Project Name:  logipi-ping
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: logipi_ping
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ping_tb IS
END ping_tb;
 
ARCHITECTURE behavior OF ping_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT logipi_ping
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         trigger_out : OUT  std_logic;
         echo_in : IN  std_logic;
         ping_enable : IN  std_logic
        );
    END COMPONENT;
	 
	 COMPONENT ping_sensor_v2
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         trigger_out : OUT  std_logic;
         echo_in : IN  std_logic;
         ping_enable : IN  std_logic;
			echo_length : out std_logic_vector(15 downto 0);
		   echo_done_out: out std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal echo_in : std_logic := '0';
   signal ping_enable : std_logic := '0';
	signal echo_length : std_logic_vector(15 downto 0);
	signal echo_done : std_logic ;

 	--Outputs
   signal trigger_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ping_sensor_v2 PORT MAP (
          clk => clk,
          reset => reset,
          trigger_out => trigger_out,
          echo_in => echo_in,
          ping_enable => ping_enable, 
			 echo_length => echo_length,
			 echo_done_out => echo_done
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      reset <= '1';
		wait for 100 ns;	
		reset <= '0';
		ping_enable <= '1' ;
		
		-- normal case
		wait until trigger_out = '1' ;
		wait until trigger_out = '0' ;
		wait for 5ms ;
		echo_in <= '1';
		wait for 15ms ;
		echo_in <= '0';
		
		-- timeout case after echo in rises
		wait until trigger_out = '1' ;
		wait until trigger_out = '0' ;
		wait for 5ms ;
		echo_in <= '1';
		
		-- timeout case after trigger sent
		wait until trigger_out = '1' ;
		echo_in <= '0';
		wait until trigger_out = '0' ;

		while true loop
				wait until trigger_out = '1' ;
				wait until trigger_out = '0' ;
				wait for 5ms ;
				echo_in <= '1';
				wait for 15ms ;
				echo_in <= '0';
		end loop ;
		
		
      wait;
   end process;

END;
