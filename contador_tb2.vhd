--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:33:58 12/21/2016
-- Design Name:   
-- Module Name:   C:/Users/Alvaro/Dropbox/Curso 2016-17/SED/Semaforos-SED/contador_tb2.vhd
-- Project Name:  Semaforos-SED
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: contador
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
 
ENTITY contador_tb2 IS
END contador_tb2;
 
ARCHITECTURE behavior OF contador_tb2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT contador
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         tiempo :  integer range 0 to 120:=0;
         cambio_estado : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal tiempo :  integer range 0 to 120:=5;

 	--Outputs
   signal cambio_estado : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1000 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: contador PORT MAP (
          clk => clk,
          reset => reset,
          tiempo => tiempo,
          cambio_estado => cambio_estado
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
		reset<='0', '1' after 2100ms, '0' after 3200ms, '1' after 4200 ms, '0' after 5100ms;
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
