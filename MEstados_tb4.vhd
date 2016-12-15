--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:38:18 12/15/2016
-- Design Name:   
-- Module Name:   C:/Users/Alvaro/Dropbox/Curso 2016-17/SED/Semaforos-SED/MEstados_tb4.vhd
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
 
ENTITY MEstados_tb4 IS
END MEstados_tb4;
 
ARCHITECTURE behavior OF MEstados_tb4 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEstados
    PORT(
         fastclk : IN  std_logic;
         rst : IN  std_logic;
         cambio_estado : IN  std_logic;
         tiempo : OUT  integer range 0 to 120;
         resetcontador : OUT  std_logic;
         pulsadorPP : IN  std_logic;
         pulsadorPS : IN  std_logic;
         sensorCS : IN  std_logic;
         sensorTR : IN  std_logic;
         SPrincipal : OUT  std_logic_vector(2 downto 0);
         SSecundario : OUT  std_logic_vector(2 downto 0);
         PPrincipal : OUT  std_logic_vector(2 downto 0);
         PSecundario : OUT  std_logic_vector(2 downto 0);
         trainIN : OUT  std_logic;
         trainOUT : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal fastclk : std_logic := '0';
   signal rst : std_logic := '0';
   signal cambio_estado : std_logic := '0';
   signal pulsadorPP : std_logic := '0';
   signal pulsadorPS : std_logic := '0';
   signal sensorCS : std_logic := '0';
   signal sensorTR : std_logic := '0';

 	--Outputs
	signal tiempo : integer range 0 to 120 := 0;
   signal resetcontador : std_logic :='1';
   signal SPrincipal : std_logic_vector(2 downto 0);
   signal SSecundario : std_logic_vector(2 downto 0);
   signal PPrincipal : std_logic_vector(2 downto 0);
   signal PSecundario : std_logic_vector(2 downto 0);
   signal trainIN : std_logic;
   signal trainOUT : std_logic;

   -- Clock period definitions
   constant fastclk_period : time := 10 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEstados PORT MAP (
          fastclk => fastclk,
          rst => rst,
          cambio_estado => cambio_estado,
          tiempo => tiempo,
          resetcontador => resetcontador,
          pulsadorPP => pulsadorPP,
          pulsadorPS => pulsadorPS,
          sensorCS => sensorCS,
          sensorTR => sensorTR,
          SPrincipal => SPrincipal,
          SSecundario => SSecundario,
          PPrincipal => PPrincipal,
          PSecundario => PSecundario,
          trainIN => trainIN,
          trainOUT => trainOUT
        );

   -- Clock process definitions
   fastclk_process :process
   begin
		fastclk <= '0';
		wait for fastclk_period/2;
		fastclk <= '1';
		wait for fastclk_period/2;
   end process;
 
   -- Stimulus process
   Peatones_principal_stim_proc: process
   begin
		--cnt<=0, 1 after 2000 ms, 2 after 3000 ms, 3 after 4000 ms, 4 after 5000 ms, 5 after 6000 ms, 6 after 7000 ms, 7 after 8000 ms, 8 after 9000 ms,9 after 10000 ms, 10 after 11000 ms;
		pulsadorPP<='0', '1' after 1000 ms, '0' after 3000ms;--, '1' after 4000 ms;
		cambio_estado<='0', '1' after 2000 ms, '0' after 2010 ms, '1' after 3000 ms, '0' after 3010 ms, '1' after 4000 ms, '0' after 4010 ms, '1' after 5000 ms, '0' after 5010 ms;
			wait; --for tsimulacion;
	
	end process;  

END;
