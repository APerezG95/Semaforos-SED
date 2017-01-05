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
			  SPrincipal: out STD_LOGIC_VECTOR(2 downto 0); --(100 es verde, 010 naranja, 001 rojo)
			  SSecundario: out STD_LOGIC_VECTOR(2 downto 0);
			  PPrincipalTop: out STD_LOGIC_VECTOR(1 downto 0); --(10 es verde, 01 es rojo)
			  PSecundarioTop: out STD_LOGIC_VECTOR(1 downto 0);	
           trainIN  : out  STD_LOGIC; -- Semáforo para girar a la derecha
           trainOUT : out  STD_LOGIC -- Semáforo en ámbar
		);
end top;

architecture Behavioral of top is	
	component MEstados is
	Port ( 	
			  fastclk: in STD_LOGIC; --Reloj a 50Mhz
			  rst : in  STD_LOGIC; -- Reset asíncrono
			  cambio_estado: in STD_LOGIC; --
			  tiempo: out integer range 0 to 120;--Cuenta 
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
	generic(
		dato: integer
	);
	port( 
			entrada : in  STD_LOGIC;
			reset : in  STD_LOGIC;
			salida : out  STD_LOGIC
	);
	end component;
	
	component contador is
   port ( clk : in  STD_LOGIC;
			 fastclk:in STD_LOGIC;
           reset : in  STD_LOGIC;
			  tiempo: in integer range 0 to 120;
			  cambio_estado: out STD_LOGIC
	);
	end component;
		

signal clksignal:  std_logic;
signal PPVsignal:  std_logic;
signal PPVPsignal: std_logic;
signal PSVsignal:  std_logic;
signal PSVPsignal: std_logic;

signal resetcnt: std_logic;
signal cuenta: integer range 0 to 120;
signal PPrincipalaux2,PPrincipalaux0,PSecundarioaux2,PSecundarioaux0: std_logic;
signal cambio: std_logic;


begin
	Inst_fsm: MEstados Port map(
			  fastclk=>clksignal,
			  rst=>rst,
			  cambio_estado=>	cambio,	
			  tiempo=>cuenta,
			  resetcontador=>resetcnt,
			  pulsadorPP=>pulsadorPP,
			  pulsadorPS=>pulsadorPS,
			  sensorCS=>sensorCS, 
			  sensorTR=>sensorTR, 
           SPrincipal=>SPrincipal,
			  SSecundario=>SSecundario,
			  PPrincipal(0)=>PPrincipalaux0,
			  PPrincipal(1)=>PPrincipaltop(0),
			  PPrincipal(2)=>PPrincipalaux2,
			  PSecundario(0)=>PSecundarioaux0,
			  PSecundario(1)=>PSecundariotop(0),
			  PSecundario(2)=>PSecundarioaux2,
           trainIN=>trainIN,
           trainOUT=>trainOUT
	);
	Inst_CLK:DFrecuencia 
	Generic map(
			dato => 24999999
	)
	Port map (
			entrada=>clkt9,
			reset=>resetcnt,
			salida=>clksignal
	);
		
	Inst_Parpadeo:DFrecuencia 
	Generic map(
			dato => 14999999
	)
	Port map (
			entrada=>clkt9,
			reset=>rst,
			salida=>clksignal
	);
		
	Inst_PSP:PSemaforos Port map (
			onoff=>PPrincipalaux2,
			blinkenable=>PPrincipalaux0,
			clk=>clksignal,
			salida=>PPrincipaltop(1)
	);
	Inst_PSS:PSemaforos Port map (
			onoff=>PSecundarioaux2,
			blinkenable=>PSecundarioaux0,
			clk=>clksignal,
			salida=>PSecundariotop(1)
	);
	Inst_Contador:contador Port map (
			clk=>clksignal,
			fastclk=>clkt9,
         reset=>resetcnt,
			tiempo=>cuenta,
			cambio_estado=>cambio
	);
	

end Behavioral;
