--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:07:00 11/24/2016
-- Design Name:   
-- Module Name:   C:/Users/Alvaro/Dropbox/Curso 2016-17/SED/Semaforos-SED/DFrecuencia_tb.vhd
-- Project Name:  Semaforos-SED
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DFrecuencia
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
 
ENTITY DFrecuencia_tb IS
END DFrecuencia_tb;
 
ARCHITECTURE behavior OF DFrecuencia_tb  IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DFrecuencia 
    PORT(
         entrada : IN  std_logic;
         reset : IN  std_logic;
         salida : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal entrada : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal salida : std_logic := '0';
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant entrada_t : time := 1 ms; 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DFrecuencia PORT MAP (
          entrada => entrada,
          reset => reset,
          salida => salida
        );

   -- Clock process definitions
   entrada_process :process
   begin
        entrada <= '0';
        wait for entrada_t/2;
        entrada <= '1';
        wait for entrada_t/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
       reset <= '0', '1' after 6200 ms, '0' after 6300 ms, '1' after 12200ms, '0' after 13000ms;
        wait;
   end process;

END;
