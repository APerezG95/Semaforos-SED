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
 

entity MEstados is
  Port ( 	
			  fastclk: in STD_LOGIC; --Reloj a 50Mhz
			  --clk : in  STD_LOGIC; -- Reloj
           rst : in  STD_LOGIC; -- Reset asíncrono
			  cnt: in integer range 0 to 120;--Cuenta 
			  resetcontador: out STD_LOGIC; --Reseteo de la entidad contador
			  pulsadorPP : in  STD_LOGIC; -- Pulsador del semáforo de peatones principal
			  pulsadorPS : in  STD_LOGIC; -- Pulsador del semáforo de peatones secundario
			  sensorCS: in STD_LOGIC; -- Sensor de vehículos en carretera secundaria
			  sensorTR: in STD_LOGIC; -- Sensor que detecta la presencia de un tren. Funciona por nivel. Mientras está a 1, hay tren en la vía. Cuando se deja de pulsar, se va.
           SPrincipal: out STD_LOGIC_VECTOR(2 downto 0); --(100 es verde, 010 naranja, 001 rojo)
			  SSecundario: out STD_LOGIC_VECTOR(2 downto 0);
			  PPrincipal: out STD_LOGIC_VECTOR(2 downto 0); --(100 verde, 010 rojo, 101 verde parpadeo)
			  PSecundario: out STD_LOGIC_VECTOR(2 downto 0);	
           trainIN : out  STD_LOGIC; -- Led que indica la presencia de un tren en la via y provoca el cierre de los dos semásforos de los coches
           trainOUT : out  STD_LOGIC -- Led que indica que el tren se ha ido y se inicia el estado de transición hacia estado S0
); 
end Mestados; 
 
--    COMPONENT MEstados
--    PORT(
--			--fastclk: IN std_logic;
--         clk : IN  std_logic;
--         rst : IN  std_logic;
--         pulsadorPP : IN  std_logic;
--         pulsadorPS : IN  std_logic;
--         sensorCS : IN  std_logic;
--         sensorTR : IN  std_logic;
--         SPV : OUT  std_logic;
--         SPR : OUT  std_logic;
--         SPN : OUT  std_logic;
--         PPV : OUT  std_logic;
--         PPVP : OUT  std_logic;
--         PPR : OUT  std_logic;
--         SSV : OUT  std_logic;
--         SSR : OUT  std_logic;
--         SSN : OUT  std_logic;
--         PSV : OUT  std_logic;
--         PSVP : OUT  std_logic;
--         PSR : OUT  std_logic;
--         trainIN : OUT  std_logic;
--         trainOUT : OUT  std_logic
--        );
--    END COMPONENT;
    
	 
	 
   --Inputs
   signal fastclk : std_logic := '0';
   signal rst : std_logic := '0';
   signal pulsadorPP : std_logic := '0';
   signal pulsadorPS : std_logic := '0';
   signal sensorCS : std_logic := '0';
   signal sensorTR : std_logic := '0';

 	--Outputs
   signal SPrincipal : std_logic_vector(2 downto 0);
   signal SSecundario : std_logic_vector(2 downto 0);
   signal PPrincipal : std_logic_vector(2 downto 0);
   signal PSecundario : std_logic_vector(2 downto 0);
   signal trainIN : std_logic;
   signal trainOUT : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1000 ms;
	constant fastclk_period: time := 10 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEstados PORT MAP (
          fastclk => fastclk,
          clk => clk,
          rst => rst,
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
		cnt<=0, 1 after 1000 ms, 2 after 2000 ms, 3 after 3000 ms, 4 after 4000 ms, 5 after 5000 ms, 6 after 6000 ms, 7 after 7000 ms, 8 after 8000 ms,9 after 9000 ms, 10 after 10000 ms;
		pulsadorPP<='0', '1' after 2000 ms, '0' after 3000ms, '1' after 4000 ms;
			wait for clk_period*10;
	
	end process;
	
	--Peatones_secundario_stim_proc:process
		--begin
		--	pulsadorPS<='0', '1' after 2000 ms;
	--	wait for clk_period*10;
	
--	QUE_VIENE_EL_TREN_stim_proc:process
--		begin
--			sensorTR<='0', '1' after 2000 ms, '0' after 4000ms;
--			
			
		wait; --for clk_period*10;
	end process;

END;

	 
--
--   --Inputs
--   signal clk : std_logic := '0';
--	--signal fastclk: std_logic:='0';
--   signal rst : std_logic := '0';
--   signal pulsadorPP : std_logic := '0';
--   signal pulsadorPS : std_logic := '0';
--   signal sensorCS : std_logic := '0';
--   signal sensorTR : std_logic := '0';
--
-- 	--Outputs
--   signal SPV : std_logic;
--   signal SPR : std_logic;
--   signal SPN : std_logic;
--   signal PPV : std_logic;
--   signal PPVP : std_logic;
--   signal PPR : std_logic;
--   signal SSV : std_logic;
--   signal SSR : std_logic;
--   signal SSN : std_logic;
--   signal PSV : std_logic;
--   signal PSVP : std_logic;
--   signal PSR : std_logic;
--   signal trainIN : std_logic;
--   signal trainOUT : std_logic;
--
--   -- Clock period definitions
--   constant clk_period : time := 1000 ms;
--
--	--constant fastclk_period: time := 10 ms;
--
-- 
--BEGIN
-- 
--	-- Instantiate the Unit Under Test (UUT)
--   uut: MEstados PORT MAP (
--          clk => clk,
--
--			 --fastclk => fastclk,
--
--
--          rst => rst,
--          pulsadorPP => pulsadorPP,
--          pulsadorPS => pulsadorPS,
--          sensorCS => sensorCS,
--          sensorTR => sensorTR,
--          SPV => SPV,
--          SPR => SPR,
--          SPN => SPN,
--          PPV => PPV,
--          PPVP => PPVP,
--          PPR => PPR,
--          SSV => SSV,
--          SSR => SSR,
--          SSN => SSN,
--          PSV => PSV,
--          PSVP => PSVP,
--          PSR => PSR,
--          trainIN => trainIN,
--          trainOUT => trainOUT
--        );
--
--   -- Clock process definitions
--   clk_process :process
--   begin
--		clk <= '0';
--		wait for clk_period/2;
--		clk <= '1';
--		wait for clk_period/2;
--   end process;
-- 
--
--	--FastClock process
--	
----	fastclk_process :process
----   begin
----		fastclk <= '0';
----		wait for fastclk_period/2;
----		fastclk <= '1';
----		wait for fastclk_period/2;
----   end process;
---- 
----
--
--   -- Stimulus process
--   --Peatones_principal_stim_proc: process
--  -- begin
--	--	pulsadorPP<='0', '1' after 2000 ms;
--	--		wait for clk_period*10;
--	
--	
--	
--	--Peatones_secundario_stim_proc:process
--		--begin
--		--	pulsadorPS<='0', '1' after 2000 ms;
--	--	wait for clk_period*10;
--	
--	QUE_VIENE_EL_TREN_stim_proc:process
--		begin
--			sensorTR<='0', '1' after 2000 ms, '0' after 6000ms;
--		wait; --for clk_period*10;
--      
--   end process;
--
--END behavior;
