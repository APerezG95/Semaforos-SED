--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:35:29 12/12/2016
-- Design Name:   
-- Module Name:   C:/Users/Adrian/Documents/Semaforos-SED/PSemaforos_tb.vhd
-- Project Name:  TrabajoSED
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PSemaforos
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
 
ENTITY PSemaforos_tb IS
END PSemaforos_tb;
 
ARCHITECTURE behavior OF PSemaforos_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PSemaforos
    PORT(
         onoff : IN  std_logic;
         blinkenable : IN  std_logic;
         clk : IN  std_logic;
         salida : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal onoff : std_logic := '0';
   signal blinkenable : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal salida : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PSemaforos PORT MAP (
          onoff => onoff,
          blinkenable => blinkenable,
          clk => clk,
          salida => salida
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
	onoff <= '0';
	wait for 1000 ms;
	onoff <= '1';
	wait for 1000 ms;
	blinkenable <= '1'
      wait;
   end process;

END;
