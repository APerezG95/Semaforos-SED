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
			  clk : in  STD_LOGIC; -- Reloj
           rst : in  STD_LOGIC; -- Reset asíncrono
			  pulsadorPP : in  STD_LOGIC; -- Pulsador del semáforo de peatones principal
			  pulsadorPS : in  STD_LOGIC; -- Pulsador del semáforo de peatones secundario
			  sensorCS: in STD_LOGIC; -- Sensor de vehículos en carretera secundaria
			  sensorTR: in STD_LOGIC; -- Sensor que detecta la presencia de un tren. Funciona por nivel. Mientras está a 1, hay tren en la vía. Cuando se deja de pulsar, se va.
           SPrincipal: out STD_LOGIC_VECTOR(2 downto 0); --(100 es verde, 010 naranja, 001 rojo)
			  SSecundario: out STD_LOGIC_VECTOR(2 downto 0);
			  PPrincipal: out STD_LOGIC_VECTOR(2 downto 0); --(100 verde, 010 rojo, 101 verde parpadeo)
			  PSecundario: out STD_LOGIC_VECTOR(2 downto 0);	  
--			  SPV : out  STD_LOGIC; -- Semáforo principal en verde
--           SPR : out  STD_LOGIC; -- Semáforo principal en rojo
--           SPN : out  STD_LOGIC; -- Semáforo principal en naranja
--           PPV : out  STD_LOGIC; -- Semáforo de peatones principal en verde
--			  PPVP: out	 STD_LOGIC; -- Entrada de habilitación para de la entidad parpadeo de semáforo peatones principal
--           PPR : out  STD_LOGIC; -- Semáforo de peatones principal en rojo
--           SSV : out  STD_LOGIC; -- Semáforo secundario en verde
--           SSR : out  STD_LOGIC; -- Semáforo secundario en rojo
--           SSN : out  STD_LOGIC; -- Semáforo secundario en naranja
--           PSV : out  STD_LOGIC; -- Semáforo de peatones secundario en verde
--			  PSVP:  out	 STD_LOGIC; -- Entrada de habilitación para de la entidad parpadeo de semáforo peatones secundario
--           PSR : out  STD_LOGIC; -- Semáforo de peatones secundario en rojo
           trainIN : out  STD_LOGIC; -- Led que indica la presencia de un tren en la via y provoca el cierre de los dos semásforos de los coches
           trainOUT : out  STD_LOGIC -- Led que indica que el tren se ha ido y se inicia el estado de transición hacia estado S0
			); 

architecture Behavioral of MEstados is

	TYPE STATES is (s0, s1, s2, s3, t1, t2);

	SIGNAL current_state: STATES;
	SIGNAL next_state: STATES;
	
	SIGNAL cambio_estado: std_logic :='0';	-- valor '1' cuando se ha llegado al tiempo requerido
	
	

	constant tambar						:integer:=4;			--tiempo máximo que van a estar los semaforos en ambar y los de los peatones parpadeando
	constant tesperapeatones			:integer:=5;			--tiempo máximo a esperar después de pulsar el botón para que pase a ambar
	constant tesperacoches				:integer:=3;			--tiempo máximo a esperar después de pulsar el botón para que pase a ambar
	constant tcarreterasecundaria 	:integer:=8;			--tiempo en el que están pasando coches por la carretera secundaria si ningún peatón pulsa pulsador.
	constant tmax							:integer:=120
	;       --constante auxiliar para poder asignar señales temporales
	
	signal tiempo		:integer range 0 to tmax;
	signal cnt			:integer range 0 to tmax; --contador 
	
	begin
	

----------- REGISTRO DE ESTADOS ---------------

	registro_de_estados: process (rst,clk)
	
			begin
			
			if rst = '1' then 
				current_state <= s0;
				 
				 
			elsif clk'event then
			
					if cambio_estado='1' then
						current_state<=next_state;			-- se cambia de estado
												
					end if;
				end if;						
	end process;
	
	
---------------- CONTADOR --------------------
	
	contador :process (clk)

		begin
						
			if rising_edge(clk) then
			
					if (cnt<tiempo) then
						cnt<=cnt+1;
						cambio_estado<='0';
						
					elsif cnt=tiempo then
						cnt<=0;									-- se reinicia la cuenta y se pone a cero la bandera
						cambio_estado<='1';
					end if;
				
			end if;
		end process;
		
		
		
--------------- PRÓXIMO ESTADO -------------

		
	proximo_estado: process (current_state, pulsadorPP, pulsadorPS, sensorTR, sensorCS)--la sentencia WAIT solo se puede usar en un proceso SIN LISTA DE SENSIBILIDAD
	
		begin 

			next_state<=current_state;

			case current_state is 

				when s0 =>
				
					if  rising_edge(sensorTR) then			-- si viene el tren, estado de emergencia T1
						next_state<= t1;
					elsif sensorCS = '1' then
						tiempo<=	tesperacoches;
						next_state <=  s1;	
					elsif pulsadorPP='1' then
						tiempo<=	tesperapeatones;
						next_state <=  s1;
					
					end if;
																	
				when s1 =>
				
					if  rising_edge(sensorTR) then			-- si viene el tren, estado de emergencia T1
						next_state<= t1;
					else
						tiempo <= tambar;							-- tiempo de ambar del semáforo principal
						next_state <= s2;
					end if;		
										
				when s2 =>
						
					if  rising_edge(sensorTR) then			-- si viene el tren, estado de emergencia T1
						next_state<= t1;
					elsif pulsadorPS = '1'  then
						tiempo <= tesperapeatones;
						next_state <= s3;	
					else
					   tiempo<= tcarreterasecundaria;
						next_state <= s3;	
							
						end if;
				
				when s3 =>
							
					if  rising_edge(sensorTR) then			-- si viene el tren, estado de emergencia T1
						next_state<= t1;
					else
						tiempo<= tambar;							-- tiempo de ambar del semáforo secundario
						next_state <= s0;
					end if;
				
				when t1 =>
				
					if falling_edge(sensorTR) then
						next_state <= t2;
					end if;
				
				when t2 =>
					tiempo<= tambar;								-- tiempo de ambar del semáforo de peatones secundario
					next_state <= s0;															
						
				when others => next_state <= s0;

		end case;

	end process;



----------------SALIDAS----------------------

salidas: process(current_state)

	begin

	case current_state is 

		when s0 =>
--					SPV      <= '0';
--					SPR      <= '1';
--					SPN      <= '1';
--					PPV      <= '1';
--					PPVP     <= '1';
--					PPR      <= '0';
--					SSV      <= '1';
--					SSR      <= '0';
--					SSN      <= '1';
--					PSV      <= '0';
--					PSVP     <= '1';
--					PSR      <= '1';
--					trainIN  <= '1';
--				   trainOUT <= '1';
				
--				SPV      <= '1';
--				SPR      <= '0';
--				SPN      <= '0';
--				PPV      <= '0';
--				PPVP     <= '0';
--				PPR      <= '1';
--				SSV      <= '0';
--				SSR      <= '1';
--				SSN      <= '0';
--				PSV      <= '1';
--				PSVP     <= '0';
--				PSR      <= '0';
--				trainIN  <= '0';
--				trainOUT <= '0';

				SPrincipal<=verde;
				SSecundario<=rojo;
				PPrincipal<=projo;
				PSecundario<=pverde;
				trainIN  <= '0';
				trainOUT <= '0';
				
		when s1 =>
--					SPV      <= '1';
--					SPR      <= '1';
--					SPN      <= '0';
--					PPV      <= '1';
--					PPVP     <= '1';
--					PPR      <= '0';
--					SSV      <= '1';
--					SSR      <= '0';
--					SSN      <= '1';
--					PSV      <= '0';
--					PSVP     <= '0';
--					PSR      <= '1';
--					trainIN  <= '1';
--				   trainOUT <= '1';
				
--				SPV      <= '0';
--				SPR      <= '0';
--				SPN      <= '1';
--				PPV      <= '0';
--				PPVP     <= '0';
--				PPR      <= '1';
--				SSV      <= '0';
--				SSR      <= '1';
--				SSN      <= '0';
--				PSV      <= '1';
--				PSVP     <= '1';
--				PSR      <= '0';
--				trainIN  <= '0';
--				trainOUT <= '0';

				SPrincipal<=naranja;
				SSecundario<=rojo;
				PPrincipal<=projo;
				PSecundario<=pverdeparpadeo;
				trainIN  <= '0';
				trainOUT <= '0';

		when s2 =>
--					SPV      <= '1';
--					SPR      <= '0';
--					SPN      <= '1';
--					PPV      <=	'0';
--					PPVP     <= '1';
--					PPR      <= '1';
--					SSV      <= '0';
--					SSR      <=	'1';
--					SSN      <=	'1';
--					PSV      <= '1';
--					PSVP     <= '1';
--					PSR      <= '0';
--					trainIN  <= '1';
--				   trainOUT <= '1';
									
--				SPV      <= '0';
--				SPR      <= '1';
--				SPN      <= '0';
--				PPV      <=	'1';
--				PPVP     <= '0';
--				PPR      <= '0';
--				SSV      <= '1';
--				SSR      <=	'0';
--				SSN      <=	'0';
--				PSV      <= '0';
--				PSVP     <= '0';
--				PSR      <= '1';
--				trainIN  <= '0';
--				trainOUT <= '0';

				SPrincipal<=rojo;
				SSecundario<=verde;
				PPrincipal<=pverde;
				PSecundario<=projo;
				trainIN  <= '0';
				trainOUT <= '0';
		
		when s3 =>
--					SPV      <= '1';
--					SPR      <= '0';
--					SPN      <= '1';
--					PPV      <=	'0';
--					PPVP     <= '0';
--					PPR      <= '1';
--					SSV      <= '1';
--					SSR      <=	'1';
--					SSN      <=	'0';
--					PSV      <= '1';
--					PSVP     <= '1';
--					PSR      <= '0';
--					trainIN  <= '1';
--				   trainOUT <= '1';

--				SPV      <= '0';
--				SPR      <= '1';
--				SPN      <= '0';
--				PPV      <=	'1';
--				PPVP     <= '1';
--				PPR      <= '0';
--				SSV      <= '0';
--				SSR      <=	'0';
--				SSN      <=	'1';
--				PSV      <= '0';
--				PSVP     <= '0';
--				PSR      <= '1';
--				trainIN  <= '0';
--				trainOUT <= '0';

				SPrincipal<=rojo;
				SSecundario<=naranja;
				PPrincipal<=projo;
				PSecundario<=pverdeparpadeo;
				trainIN  <= '0';
				trainOUT <= '0';

		when t1 => 
--					SPV      <= '1';
--					SPR      <= '0';
--					SPN      <= '1';
--					PPV      <= '0';
--					PPVP     <= '1';
--					PPR      <= '1';
--					SSV      <= '1';
--					SSR      <= '0';
--					SSN      <= '1';
--					PSV      <= '0';
--					PSVP     <= '1';
--					PSR      <= '1';
--					trainIN  <= '0';
--				   trainOUT <=	'1';	
				
--				SPV      <= '0';
--				SPR      <= '1';
--				SPN      <= '0';
--				PPV      <= '1';
--				PPVP     <= '0';
--				PPR      <= '0';
--				SSV      <= '0';
--				SSR      <= '1';
--				SSN      <= '0';
--				PSV      <= '1';
--				PSVP     <= '0';
--				PSR      <= '0';
--				trainIN  <= '1';
--				trainOUT <=	'0';	

				SPrincipal<=rojo;
				SSecundario<=rojo;
				PPrincipal<=pverde;
				PSecundario<=pverde;
				trainIN  <= '1';
				trainOUT <= '0';
		
		when t2 => 
--					SPV      <= '1';
--					SPR      <= '0';
--					SPN      <= '1';
--					PPV      <= '0';
--					PPVP     <= '0';
--					PPR      <= '1';
--					SSV      <= '1';
--					SSR      <= '0';
--					SSN      <= '1';
--					PSV      <= '0';
--					PSVP     <= '1';
--					PSR      <= '1';
--					trainIN  <= '1';
--				   trainOUT <=	'0';
				
				SPrincipal<=rojo;
				SSecundario<=rojo;
				PPrincipal<=pverdeparpadeo;
				PSecundario<=pverde;
				trainIN  <= '0';
				trainOUT <= '1';
				
				
--		when others => 
----					SPV      <= '1';
----					SPN      <= '1';
----					PPV      <= '1';
----					PPVP     <= '1';
----					PPR      <= '1';
----					SSV      <= '1';
----					SSR      <= '1';
----					SSN      <= '1';
----					PSV      <= '1';
----					PSVP     <= '1';
----					PSR      <= '1';
----					trainIN  <= '1';
----				   trainOUT <=	'1';	
--				
----				SPV      <= '0';
----				SPN      <= '0';
----				PPV      <= '0';
----				PPVP     <= '0';
----				PPR      <= '0';
----				SSV      <= '0';
----				SSR      <= '0';
----				SSN      <= '0';
----				PSV      <= '0';
----				PSVP     <= '0';
----				PSR      <= '0';
----				trainIN  <= '0';
----				trainOUT <=	'0';	
--				SPrincipal<=verde;
--				SSecundario<=apa;
--				PPrincipal<=pverde;
--				PSecundario<=pverde;
--				trainIN  <= '0';
--				trainOUT <= '0';

	end case;
	end process;
	
end Behavioral;
