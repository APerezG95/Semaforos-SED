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
-- Module Name:    MEstados - Behavioral 
-- Project Name:   Cruce de semáforos
-- Target Devices: Xilinx Spartan 3
-- Tool versions: 
-- Description: Esta entidad gestiona la maquina de estados y sus transiciones
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

entity MEstados is
  Port ( 	
			  fastclk: in STD_LOGIC; --Reloj a 50Mhz
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


architecture Behavioral of MEstados is

	TYPE STATES is (s0, s1, s2, s3, t1, t2);

	SIGNAL current_state, next_state: STATES;

	constant verde: std_logic_vector(2 downto 0):="100"; --(100 es verde, 010 naranja, 001 rojo)
	constant naranja: std_logic_vector(2 downto 0):="010";
	constant rojo: std_logic_vector(2 downto 0):="001";
	constant pverde: std_logic_vector(2 downto 0):="100"; --(100 verde, 010 rojo, 101 verde parpadeo)
	constant pverdeparpadeo: std_logic_vector(2 downto 0):="101";
	constant projo: std_logic_vector(2 downto 0) :="010";

	constant tambar						:integer:=4;			--tiempo máximo que van a estar los semaforos en ambar y los de los peatones parpadeando
	constant tesperapeatones			:integer:=5;			--tiempo máximo a esperar después de pulsar el botón para que pase a ambar
	constant tesperacoches				:integer:=3;			--tiempo máximo a esperar después de pulsar el botón para que pase a ambar
	constant tcarreterasecundaria 	:integer:=8;			--tiempo en el que están pasando coches por la carretera secundaria si ningún peatón pulsa pulsador.
	 constant tmax							:integer:=120;       --constante auxiliar para poder asignar señales temporales
	
	signal resetcnt:std_logic; --Reset del contador
	signal fin_tambar, fin_tesperapeatones, fin_tesperacoches, fin_tcarreterasecundaria :boolean;
	
	begin
	

--------------- PRÓXIMO ESTADO -------------
	
	proximo_estado: process (fastclk,rst)--la sentencia WAIT solo se puede usar en un proceso SIN LISTA DE SENSIBILIDAD
	begin
		if rst='1' then
			next_state<=s0;
		else
			if rising_edge(fastclk) then
				case current_state is 
					when s0 =>
					
						if  rising_edge(sensorTR) then			-- si viene el tren, estado de emergencia T1
							next_state<= t1;
						elsif sensorCS = '1' then
							resetcnt<='1';
							if fin_tesperacoches then
							next_state <=  s1;
							end if;
						elsif pulsadorPP='1' then
							resetcnt<='1';
							if fin_tesperapeatones then
							next_state <=  s1;
							end if;
						end if;
																		
					when s1 =>
					
						if  rising_edge(sensorTR) then			-- si viene el tren, estado de emergencia T1
							resetcnt<='1';
							next_state<= t1;
						else
							resetcnt<='1';
							if fin_tambar then							-- tiempo de ambar del semáforo principal
							next_state <= s2;
							end if;
						end if;		
											
					when s2 =>
							
						if  rising_edge(sensorTR) then			-- si viene el tren, estado de emergencia T1
							next_state<= t1;
						elsif pulsadorPS = '1'  then
							resetcnt<='1';
							if fin_tesperapeatones then
							next_state <= s3;
							end if;
						else
							resetcnt<= '1';
							if fin_tcarreterasecundaria then
							next_state <= s3;		
							end if;
						end if;
					
					when s3 =>
								
						if  rising_edge(sensorTR) then			-- si viene el tren, estado de emergencia T1
							next_state<= t1;
						else
							resetcnt<='1';
							if fin_tambar then						-- tiempo de ambar del semáforo secundario
							next_state <= s0;
							end if;
						end if;
					
					when t1 =>
					
						if falling_edge(sensorTR) then
							next_state <= t2;
						end if;
					
					when t2 =>
						resetcnt<='1';
						if fin_tambar then								-- tiempo de ambar del semáforo de peatones secundario
						next_state <= s0;	
						end if;
							
					when others => next_state <= s0;
				end case;
			end if;	
		end if;
	end process;
	
	current_state<=next_state;	
----------------SALIDAS----------------------

	salidas: process(current_state)

		begin
		case current_state is 

			when s0 =>
					SPrincipal<=verde;
					SSecundario<=rojo;
					PPrincipal<=projo;
					PSecundario<=pverde;
					trainIN  <= '0';
					trainOUT <= '0';
					resetcontador <= resetcnt;
					
			when s1 =>
					SPrincipal<=naranja;
					SSecundario<=rojo;
					PPrincipal<=projo;
					PSecundario<=pverdeparpadeo;
					trainIN  <= '0';
					trainOUT <= '0';
					resetcontador <= resetcnt;

			when s2 =>
					SPrincipal<=rojo;
					SSecundario<=verde;
					PPrincipal<=pverde;
					PSecundario<=projo;
					trainIN  <= '0';
					trainOUT <= '0';
					resetcontador <= resetcnt;
			
			when s3 =>
					SPrincipal<=rojo;
					SSecundario<=naranja;
					PPrincipal<=projo;
					PSecundario<=pverdeparpadeo;
					trainIN  <= '0';
					trainOUT <= '0';
					resetcontador <= resetcnt;
				

			when t1 => 
					SPrincipal<=rojo;
					SSecundario<=rojo;
					PPrincipal<=pverde;
					PSecundario<=pverde;
					trainIN  <= '1';
					trainOUT <= '0';
					resetcontador <= resetcnt;
			
			when t2 => 
					SPrincipal<=rojo;
					SSecundario<=rojo;
					PPrincipal<=pverdeparpadeo;
					PSecundario<=pverde;
					trainIN  <= '0';
					trainOUT <= '1';
					resetcontador <= resetcnt;
					
					
	--		when others => 
		end case;
	end process;
	
fin_tambar<=true when cnt=tambar else false;			--tiempo máximo que van a estar los semaforos en ambar y los de los peatones parpadeando
fin_tesperapeatones<=true when cnt=tesperapeatones else false;			--tiempo máximo a esperar después de pulsar el botón para que pase a ambar
fin_tesperacoches<=true when cnt=tesperacoches else false;			--tiempo máximo a esperar después de pulsar el botón para que pase a ambar
fin_tcarreterasecundaria<=true when cnt=tcarreterasecundaria else false;			--tiempo en el que están pasando coches por la carretera secundaria si ningún peatón pulsa pulsador.
	
end Behavioral;
