----------------------------------------------------------------------------------
-- University:    Universidad Politécnica de Madrid
-- School			Escuela Técnica Superior de Ingeneria y Diseño Industrial
-- Subject			Sistemas Infomáticos Digitales
-- Engineers: 		Adrían Pérez
--						Jorge Scharfhausen
--						Alvaro Zornoza
-- 
-- Create Date:    16:02:34 11/22/2016 
-- Design Name:    Trabajo de la asignatura.
-- Module Name:    PSemaforos - Behavioral 
-- Project Name:   Cruce de semáforos
-- Target Devices: Xilinx Spartan 3
-- Tool versions: 
-- Description: Esta entidad se encarga de reunir el resto de entidades
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
		port (			
			  clkt9 : in  STD_LOGIC; -- Reloj
           rst : in  STD_LOGIC; -- Reset asíncrono
			  pulsadorPP : in  STD_LOGIC; -- Pulsador del semáforo de peatones principal
			  pulsadorPS : in  STD_LOGIC; -- Pulsador del semáforo de peatones secundario
			  sensorCS: in STD_LOGIC; --
			  sensorTR:	in STD_LOGIC;
           SPV : out  STD_LOGIC; -- Semáforo principal en verde
           SPR : out  STD_LOGIC; -- Semáforo principal en rojo
           SPN : out  STD_LOGIC; -- Semáforo principal en naranja
           PPV : out  STD_LOGIC; -- Semáforo de peatones principal en verde
           PPR : out  STD_LOGIC; -- Semáforo de peatones principal en rojo
           SSV : out  STD_LOGIC; -- Semáforo secundario en verde
           SSR : out  STD_LOGIC; -- Semáforo secundario en rojo
           SSN : out  STD_LOGIC; -- Semáforo secundario en naranja
           PSV : out  STD_LOGIC; -- Semáforo de peatones secundario en verde
           PSR : out  STD_LOGIC; -- Semáforo de peatones secundario en rojo
           trainIN  : out  STD_LOGIC; -- Semáforo para girar a la derecha
           trainOUT : out  STD_LOGIC -- Semáforo en ámbar
		);
end top;

architecture Behavioral of top is	
	component MEstados is
	Port ( 	
			  fastclk: in STD_LOGIC; --Reloj de la FPGA
			  clk : in  STD_LOGIC; -- Reloj
			  rst : in  STD_LOGIC; -- Reset asíncrono
			  pulsadorPP : in  STD_LOGIC; -- Pulsador del semáforo de peatones principal
			  pulsadorPS : in  STD_LOGIC; -- Pulsador del semáforo de peatones secundario
			  sensorCS: in STD_LOGIC; -- Sensor de vehículos en carretera secundaria
			  sensorTR: in STD_LOGIC; -- Sensor que detecta la presencia de un tren. Funciona por nivel. Mientras está a 1, hay tren en la vía. Cuando se deja de pulsar, se va.
			  SPV : out  STD_LOGIC; -- Semáforo principal en verde
			  SPR : out  STD_LOGIC; -- Semáforo principal en rojo
			  SPN : out  STD_LOGIC; -- Semáforo principal en naranja
			  PPV : out  STD_LOGIC; -- Semáforo de peatones principal en verde
			  PPVP: out	 STD_LOGIC; -- Entrada de habilitación para de la entidad parpadeo de semáforo peatones principal
			  PPR : out  STD_LOGIC; -- Semáforo de peatones principal en rojo
			  SSV : out  STD_LOGIC; -- Semáforo secundario en verde
			  SSR : out  STD_LOGIC; -- Semáforo secundario en rojo
			  SSN : out  STD_LOGIC; -- Semáforo secundario en naranja
			  PSV : out  STD_LOGIC; -- Semáforo de peatones secundario en verde
			  PSVP:  out	 STD_LOGIC; -- Entrada de habilitación para de la entidad parpadeo de semáforo peatones secundario
			  PSR : out  STD_LOGIC; -- Semáforo de peatones secundario en rojo
			  trainIN : out  STD_LOGIC; -- Led que indica la presencia de un tren en la via y provoca el cierre de los dos semásforos de los coches
			  trainOUT : out  STD_LOGIC -- Led que indica que el tren se ha ido y se inicia el estado de transición hacia estado S0
	); 
	end component;

	component PSemaforos is
	port(
			onoff: in std_logic;
			blinkenable: in std_logic;
			clk: in std_logic;
			salida: out std_logic
	);
	end component;

	component DFrecuencia is
	port( 
			entrada : in  STD_LOGIC;
			reset : in  STD_LOGIC;
			salida : out  STD_LOGIC
	);
	end component;

signal clksignal:  std_logic;
signal PPVsignal:  std_logic;
signal PPVPsignal: std_logic;
signal PSVsignal:  std_logic;
signal PSVPsignal: std_logic;

begin
	Inst_fsm: MEstados Port map(
			  fastclk => clkt9,
			  clk => clksignal, 
			  rst => rst,
			  pulsadorPP => pulsadorPP, 
			  pulsadorPS =>  pulsadorPS, 
			  sensorCS => sensorCS,
			  sensorTR => sensorTR,
			  SPV => SPV,
			  SPR =>	SPR, 
			  SPN => SPN,
			  PPV =>	PPVsignal,
			  PPVP => PPVPsignal,
			  PPR =>	PPR,
			  SSV =>	SSV,
			  SSR => SSR,
			  SSN =>	SSN,
			  PSV => PSVsignal,
			  PSVP => PSVPsignal,
			  PSR => PSR,
			  trainin => trainin,
			  trainout => trainout
	);
	Inst_DivFrec:DFrecuencia Port map (
			entrada=>clkt9,
			reset=>rst,
			salida=>clksignal
		);
	Inst_PSP:PSemaforos Port map (
			onoff=>PPVsignal,
			blinkenable=>PPVPsignal,
			clk=>clksignal,
			salida=>PPV
	);
	Inst_PSS:PSemaforos Port map (
			onoff=>PSVsignal,
			blinkenable=>PSVPsignal,
			clk=>clksignal,
			salida=>PSV
	);
	

end Behavioral;
