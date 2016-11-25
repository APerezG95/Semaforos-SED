--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:53:14 11/24/2016
-- Design Name:   
-- Module Name:   D:/SED/Semaforos-SED/MEstados_tb.vhd
-- Project Name:  Semaforos-SED
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MEstados
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
 
ENTITY MEstados_tb IS
END MEstados_tb;
 
ARCHITECTURE behavior OF MEstados_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEstados
    PORT(
			fastclk: IN std_logic;
         clk : IN  std_logic;
         rst : IN  std_logic;
         pulsadorPP : IN  std_logic;
         pulsadorPS : IN  std_logic;
         sensorCS : IN  std_logic;
         sensorTR : IN  std_logic;
         SPV : OUT  std_logic;
         SPR : OUT  std_logic;
         SPN : OUT  std_logic;
         PPV : OUT  std_logic;
         PPVP : OUT  std_logic;
         PPR : OUT  std_logic;
         SSV : OUT  std_logic;
         SSR : OUT  std_logic;
         SSN : OUT  std_logic;
         PSV : OUT  std_logic;
         PSVP : OUT  std_logic;
         PSR : OUT  std_logic;
         trainIN : OUT  std_logic;
         trainOUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
	signal fastclk: std_logic:='0';
   signal rst : std_logic := '0';
   signal pulsadorPP : std_logic := '0';
   signal pulsadorPS : std_logic := '0';
   signal sensorCS : std_logic := '0';
   signal sensorTR : std_logic := '0';

 	--Outputs
   signal SPV : std_logic;
   signal SPR : std_logic;
   signal SPN : std_logic;
   signal PPV : std_logic;
   signal PPVP : std_logic;
   signal PPR : std_logic;
   signal SSV : std_logic;
   signal SSR : std_logic;
   signal SSN : std_logic;
   signal PSV : std_logic;
   signal PSVP : std_logic;
   signal PSR : std_logic;
   signal trainIN : std_logic;
   signal trainOUT : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1000 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEstados PORT MAP (
          clk => clk,
          rst => rst,
          pulsadorPP => pulsadorPP,
          pulsadorPS => pulsadorPS,
          sensorCS => sensorCS,
          sensorTR => sensorTR,
          SPV => SPV,
          SPR => SPR,
          SPN => SPN,
          PPV => PPV,
          PPVP => PPVP,
          PPR => PPR,
          SSV => SSV,
          SSR => SSR,
          SSN => SSN,
          PSV => PSV,
          PSVP => PSVP,
          PSR => PSR,
          trainIN => trainIN,
          trainOUT => trainOUT
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
   --Peatones_principal_stim_proc: process
  -- begin
	--	pulsadorPP<='0', '1' after 2000 ms;
	--		wait for clk_period*10;
	
	
	
	--Peatones_secundario_stim_proc:process
		--begin
		--	pulsadorPS<='0', '1' after 2000 ms;
	--	wait for clk_period*10;
	
	QUE_VIENE_EL_TREN_stim_proc:process
		begin
			sensorTR<='0', '1' after 2000 ms;
		wait for clk_period*10;
      
   end process;

END behavior;
