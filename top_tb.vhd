--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:36:58 12/15/2016
-- Design Name:   
-- Module Name:   C:/Users/Alvaro/Dropbox/Curso 2016-17/SED/Semaforos-SED/top_tb.vhd
-- Project Name:  Semaforos-SED
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
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
 
ENTITY top_tb IS
END top_tb;
 
ARCHITECTURE behavior OF top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         clkt9 : IN  std_logic;
         rst : IN  std_logic;
         pulsadorPP : IN  std_logic;
         pulsadorPS : IN  std_logic;
         sensorCS : IN  std_logic;
         sensorTR : IN  std_logic;
         SPrincipal : OUT  std_logic_vector(2 downto 0);
         SSecundario : OUT  std_logic_vector(2 downto 0);
         PPrincipalTop : OUT  std_logic_vector(1 downto 0);
         PSecundarioTop : OUT  std_logic_vector(1 downto 0);
         trainIN : OUT  std_logic;
         trainOUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clkt9 : std_logic := '0';
   signal rst : std_logic := '0';
   signal pulsadorPP : std_logic := '0';
   signal pulsadorPS : std_logic := '0';
   signal sensorCS : std_logic := '0';
   signal sensorTR : std_logic := '0';

 	--Outputs
   signal SPrincipal : std_logic_vector(2 downto 0);
   signal SSecundario : std_logic_vector(2 downto 0);
   signal PPrincipalTop : std_logic_vector(1 downto 0);
   signal PSecundarioTop : std_logic_vector(1 downto 0);
   signal trainIN : std_logic;
   signal trainOUT : std_logic;

   -- Clock period definitions
   constant clkt9_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          clkt9 => clkt9,
          rst => rst,
          pulsadorPP => pulsadorPP,
          pulsadorPS => pulsadorPS,
          sensorCS => sensorCS,
          sensorTR => sensorTR,
          SPrincipal => SPrincipal,
          SSecundario => SSecundario,
          PPrincipalTop => PPrincipalTop,
          PSecundarioTop => PSecundarioTop,
          trainIN => trainIN,
          trainOUT => trainOUT
        );

   -- Clock process definitions
   clkt9_process :process
   begin
		clkt9 <= '0';
		wait for clkt9_period/2;
		clkt9 <= '1';
		wait for clkt9_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      sensorTR<='0', '1' after 1100 ms, '0' after 4000ms;

      wait;

      -- insert stimulus here 

      --wait;
   end process;

END;
