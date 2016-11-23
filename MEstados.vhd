----------------------------------------------------------------------------------
-- University:    Universidad Polit�cnica de Madrid
-- School			Escuela T�cnica Superior de Ingeneria y Dise�o Industrial
-- Subject			Sistemas Infom�ticos Digitales
-- Engineers: 		Adr�an P�rez
--						Jorge Scharfhausen
--						Alvaro Zornoza
-- 
-- Create Date:    16:02:34 11/22/2016 
-- Design Name:    Trabajo de la asignatura.
-- Module Name:    MEstados - Behavioral 
-- Project Name:   Cruce de sem�foros
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
			  clk : in  STD_LOGIC; -- Reloj
           rst : in  STD_LOGIC; -- Reset as�ncrono
			  pulsadorPP : in  STD_LOGIC; -- Pulsador del sem�foro de peatones principal
			  pulsadorPS : in  STD_LOGIC; -- Pulsador del sem�foro de peatones secundario
			  sensorCS: in STD_LOGIC; -- Sensor de veh�culos en carretera secundaria
			  sensorTR: in STD_LOGIC; -- Sensor que detecta la presencia de un tren. Funciona por nivel. Mientras est� a 1, hay tren en la via
           SPV : out  STD_LOGIC; -- Sem�foro principal en verde
           SPR : out  STD_LOGIC; -- Sem�foro principal en rojo
           SPN : out  STD_LOGIC; -- Sem�foro principal en naranja
           PPV : out  STD_LOGIC; -- Sem�foro de peatones principal en verde
			  PPVP: out	 STD_LOGIC; -- Entrada de habilitaci�n para de la entidad parpadeo de sem�foro peatones principal
           PPR : out  STD_LOGIC; -- Sem�foro de peatones principal en rojo
           SSV : out  STD_LOGIC; -- Sem�foro secundario en verde
           SSR : out  STD_LOGIC; -- Sem�foro secundario en rojo
           SSN : out  STD_LOGIC; -- Sem�foro secundario en naranja
           PSV : out  STD_LOGIC; -- Sem�foro de peatones secundario en verde
			  PSVP:  out	 STD_LOGIC; -- Entrada de habilitaci�n para de la entidad parpadeo de sem�foro peatones secundario
           PSR : out  STD_LOGIC; -- Sem�foro de peatones secundario en rojo
           trainIN : out  STD_LOGIC; -- Led que indica la presencia de un tren en la via y provoca el cierre de los dos sem�sforos de los coches
           trainOUT : out  STD_LOGIC -- Led que indica que el tren se ha ido y se inicia el estado de transici�n hacia estado S0
			); 
end MEstados;


architecture Behavioral of MEstados is

	TYPE STATES is (s0, s1, s2, s3, t1, t2);

	SIGNAL current_state: STATES;
	SIGNAL next_state: STATES;
	
	signal cambio_estado: std_logic;	-- valor '1' cuando se ha llegado al tiempo requerido
	
	
	
	constant tmax: integer :=15;			--tiempo m�ximo que van a estar los semaforos
	constant tambar:integer:=4;			--tiempo m�ximo que van a estar los semaforos en ambar
	constant tespera:integer:=4;			--tiempo m�ximo a esperar despu�s de pulsar el bot�n para que pase a ambar
	
	signal tiempo:integer range 0 to tmax;
	
	signal cnt: integer range 0 to tmax; --contador 
	
	begin
	

----------- REGISTRO DE ESTADOS ---------------

	registro_de_estados: process (rst,clk)
	
			begin
			
			if rst = '1' then 
				current_state <= s0;
				 
				 
			elsif rising_edge(clk) then
			
					if cambio_estado='1' then
						current_state<=next_state;			-- se cambia de estado, se reinicia la cuenta y se pone a cero la bandera
												
					end if;
				end if;						
	end process;
	
	
----------------------CONTADOR------------------
	
	contador :process (clk)
		
		begin
						
			if rising_edge(clk) then
			
					if (cnt<tiempo) then
						cnt<=cnt+1;
						cambio_estado<='0';
						
					elsif cnt=tiempo then
						cambio_estado<='1';
						cnt<=0;
						
					end if;
				
			end if;
		end process;
		
		
		
------------------ PR�XIMO ESTADO -----------------------------

		
	proximo_estado: process (current_state, pulsadorPP, pulsadorPS)--la sentencia WAIT solo se puede usar en un proceso SIN LISTA DE SENSIBILIDAD
	
		begin 

			next_state<=current_state;

			case current_state is 

				when s0 =>
						
						if pulsadorPP = '1' then  
								tiempo<=	tespera;-- Si se da al pulsador, esperamos el tiempo de espera, 
								next_state<=s1;				--	y en el siguiente ciclo de reloj se cambiar�a de estado al estar activada la bandera de cambio de estado
								
						else
											-- Si no se ha dado a ning�n pulsador, cuando la cuenta llegue al m�ximo se cambia de estado
								tiempo<=tmax;
								next_state <= s1;
								
							
						end if;
						
				when s1 =>
					
							tiempo<=tambar;
							next_state <= s2;
							
				when s2 =>
						
						if (pulsadorPP = '1' or pulsadorPS = '1') then
								tiempo<=tespera; 
								next_state<=s3;		
																
						else
								tiempo<=tmax; 
								next_state <= s3;
							
						end if;
				
				when s3 =>
							
							tiempo<=tambar;
							next_state <= s0;
					
						
				when others => next_state <= s0;

		end case;

	end process;



----------------SALIDAS----------------------

	salidas: process(current_state)
	
		begin

		case current_state is 

			when s0 =>
					SPV      <= '1'
					SPR      <= '0'
					SPN      <= '0'
					PPV      <= '0'
					PPVP     <= '0'
					PPR      <= '1'
					SSV      <= '0'
					SSR      <= '1'
					SSN      <= '0'
					PSV      <= '1'
					PSVP     <= '0'
					PSR      <= '0'
					trainIN  <= '0'
				   trainOUT <= '0'
					
			when s1 =>
					SPV      <= '0'
					SPR      <= '0'
					SPN      <= '1'
					PPV      <= '0'
					PPVP     <= '0'
					PPR      <= '0'
					SSV      <= '0'
					SSR      <= '1'
					SSN      <= '0'
					PSV      <= '1'
					PSVP     <= '1'
					PSR      <= '0'
					trainIN  <= '0'
				   trainOUT <= '0'

			when s2 =>
					SPV      <= '0'
					SPR      <= '1'
					SPN      <= '0'
					PPV      <=	'1'
					PPVP     <= '0'
					PPR      <= '0'
					SSV      <= '1'
					SSR      <=	'0'
					SSN      <=	'0'
					PSV      <= '0'
					PSVP     <= '0'
					PSR      <= '1'
					trainIN  <= '0'
				   trainOUT <= '0'
			
			when s3 =>
					SPV      <= '0'
					SPR      <= '1'
					SPN      <= '0'
					PPV      <=	'1'
					PPVP     <= '1'
					PPR      <= '0'
					SSV      <= '0'
					SSR      <=	'0'
					SSN      <=	'1'
					PSV      <= '0'
					PSVP     <= '0'
					PSR      <= '1'
					trainIN  <= '0'
				   trainOUT <= '0'
					
			when t1 => 
					SPV      <= '0';
					SPR      <= '1';
					SPN      <= '0';
					PPV      <= '1';
					PPVP     <= '0';
					PPR      <= '0';
					SSV      <= '0';
					SSR      <= '1';
					SSN      <= '0';
					PSV      <= '1';
					PSVP     <= '0';
					PSR      <= '0';
					trainIN  <= '1';
				   trainOUT <=	'0';	
					
			when t2 => 
					SPV      <= '0';
					SPR      <= '1';
					SPN      <= '0';
					PPV      <= '1';
					PPVP     <= '1';
					PPR      <= '0';
					SSV      <= '0';
					SSR      <= '1';
					SSN      <= '0';
					PSV      <= '1';
					PSVP     <= '0';
					PSR      <= '0';
					trainIN  <= '0';
				   trainOUT <=	'1';	
					
			when others => 
					SPV      <= '0';
					SPN      <= '0';
					PPV      <= '0';
					PPVP     <= '0';
					PPR      <= '0';
					SSV      <= '0';
					SSR      <= '0';
					SSN      <= '0';
					PSV      <= '0';
					PSVP     <= '0';
					PSR      <= '0';
					trainIN  <= '0';
				   trainOUT <=	'0';	
		end case;

	end process;

end Behavioral;