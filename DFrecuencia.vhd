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
-- Module Name:    DFrecuencia - Behavioral 
-- Project Name:   Cruce de semáforos
-- Target Devices: Xilinx Spartan 3
-- Tool versions: 
-- Description: Esta entidad toma la señal de 50Mhz de la FPGA y divide la frecuencia a 1HZ
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
----------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
entity DFrecuencia is
    Port ( entrada : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           salida : out  STD_LOGIC
			  );
end DFrecuencia;

architecture Behavioral of DFrecuencia is
	signal temporal, temporal_clkfast: STD_LOGIC;
   signal contador: integer range 0 to 24999999 := 0; -- De 50 MHz a 1 Hz
	
begin
divisor_frecuencia: process (reset, entrada) 
	begin
        if (reset = '1') then
            temporal <= '0';
            contador <= 0;
        elsif rising_edge(entrada) then
            if (contador = 24999999) then
                temporal <= NOT(temporal);
                contador <= 0;
            else
                contador <= contador+1;
            end if;
        end if;
    end process; 
	 

	 salida <= temporal;
	 
 end Behavioral;




