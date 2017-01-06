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
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;



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
			end Mestados;


architecture Behavioral of MEstados is

	TYPE STATES is (s0, s1, s2, s3, t1, t2, s11, s12, s13, aux1,aux2,aux3,aux4); --con los estados aux consigo resetear el contador

	SIGNAL current_state,next_state: STATES:=s0;

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

	begin

------------- REGISTRO DE ESTADOS ---------------
	
	registro_de_estados: process(fastclk, rst)
		begin
			if rst='1' then
				current_state<=s0;
			elsif rising_edge(fastclk) then
				current_state<=next_state;
			end if;
		end process;
		
----------------- PRÓXIMO ESTADO -------------	
	
	proximo_estado: process(current_state, cambio_estado, sensorTR, sensorCS, pulsadorPS, pulsadorPP)
		begin
			case current_state is
				when s0 =>
					if sensorTR='1' then			-- si viene el tren, estado de emergencia T1
						next_state <= t1;	
					elsif sensorCS='1' then
						next_state <= s11;
					elsif pulsadorPP='1' then
						next_state <= s12;
					end if;
			
				when s1 =>
					tiempo <= tambar;
					if sensorTR='1' then			-- si viene el tren, estado de emergencia T1
						next_state <= t1;	
					elsif cambio_estado = '1' then
						next_state <= aux2; 
					end if;
		
				when s2 =>
					tiempo <= tcarreterasecundaria;
					if sensorTR='1' then			-- si viene el tren, estado de emergencia T1
						next_state <= t1;
					elsif pulsadorPS='1' then
						next_state <= aux3;
					elsif cambio_estado = '1' then
						next_state <= aux4;
					end if;
						
				when s3 =>
					tiempo <= tambar;
					if sensorTR='1' then			-- si viene el tren, estado de emergencia T1
						next_state <= t1;	
					elsif cambio_estado = '1' then
						next_state <= s0; 
					end if;
			
				when t1 =>
					if sensorTR='0' then
						next_state <= t2;
					end if;

				when t2 =>	
					tiempo <= tambar;
					if cambio_estado = '1' then
						next_state <= s0;
					end if; 
					
				when s11 =>
					tiempo <= tesperacoches;
					if cambio_estado = '1' then
						next_state <= aux1;
					end if;
					
				when s12 =>
					tiempo <= tesperapeatones;
					if cambio_estado = '1' then
						next_state <= aux1;
					end if;				
				
				when s13 =>
					tiempo <= tesperapeatones;
					if cambio_estado = '1' then
						next_state <= aux4;
					end if;
					
				when aux1 =>
					next_state <= s1;
				when aux2 =>
					next_state <= s2;
				when aux3 =>
					next_state <= s13;
				when aux4 =>
					next_state <= s3;
				
				when others =>
					next_state <= s0;
			end case;			
	end process;
			
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
					resetcontador <= '1';
					
			when s11 =>
					SPrincipal<=verde;
					SSecundario<=rojo;
					PPrincipal<=projo;
					PSecundario<=pverde;
					trainIN  <= '0';
					trainOUT <= '0';
					resetcontador <= '0';
					
			when s12 =>
					SPrincipal<=verde;
					SSecundario<=rojo;
					PPrincipal<=projo;
					PSecundario<=pverde;
					trainIN  <= '0';
					trainOUT <= '0';
					resetcontador <= '0';
					
			when aux1 =>
					SPrincipal<=verde;
					SSecundario<=rojo;
					PPrincipal<=projo;
					PSecundario<=pverde;
					trainIN  <= '0';
					trainOUT <= '0';
					resetcontador <= '1';
					
			when s1 =>
					SPrincipal<=naranja;
					SSecundario<=rojo;
					PPrincipal<=projo;
					PSecundario<=pverdeparpadeo;
					trainIN  <= '0';
					trainOUT <= '0';
					resetcontador <= '0';
					
			when aux2 =>
					SPrincipal<=naranja;
					SSecundario<=rojo;
					PPrincipal<=projo;
					PSecundario<=pverdeparpadeo;
					trainIN  <= '0';
					trainOUT <= '0';
					resetcontador <= '1';

			when s2 =>
					SPrincipal<=rojo;
					SSecundario<=verde;
					PPrincipal<=pverde;
					PSecundario<=projo;
					trainIN  <= '0';
					trainOUT <= '0';
					resetcontador <= '0';
					
			when aux3 =>
					SPrincipal<=rojo;
					SSecundario<=verde;
					PPrincipal<=pverde;
					PSecundario<=projo;
					trainIN  <= '0';
					trainOUT <= '0';
					resetcontador <= '1';
					
			when s13 =>
					SPrincipal<=rojo;
					SSecundario<=verde;
					PPrincipal<=pverde;
					PSecundario<=projo;
					trainIN  <= '0';
					trainOUT <= '0';
					resetcontador <= '0';
			
			when aux4 =>
					SPrincipal<=rojo;
					SSecundario<=verde;
					PPrincipal<=pverde;
					PSecundario<=projo;
					trainIN  <= '0';
					trainOUT <= '0';
					resetcontador <= '1';
			
			when s3 =>
					SPrincipal<=rojo;
					SSecundario<=naranja;
					PPrincipal<=pverdeparpadeo;
					PSecundario<=projo;
					trainIN  <= '0';
					trainOUT <= '0';
					resetcontador <= '0';

			when t1 => 
					SPrincipal<=rojo;
					SSecundario<=rojo;
					PPrincipal<=pverde;
					PSecundario<=pverde;
					trainIN  <= '1';
					trainOUT <= '0';
					resetcontador <= '1';
			
			when t2 => 
					SPrincipal<=rojo;
					SSecundario<=rojo;
					PPrincipal<=pverdeparpadeo;
					PSecundario<=pverde;
					trainIN  <= '0';
					trainOUT <= '1';
					resetcontador <= '0';
		end case;
	end process;
	
end Behavioral;
