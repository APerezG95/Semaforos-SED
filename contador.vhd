----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:13:22 12/13/2016 
-- Design Name: 
-- Module Name:    contador - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
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

entity contador is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
			  cuenta: out integer range 0 to 120);
end contador;

architecture Behavioral of contador is

constant tmax	:integer:=120;       --constante auxiliar para poder asignar señales temporales
signal cnt		:integer range 0 to tmax:=0; --contador 
 
begin 

process (clk,reset)
	begin
		if rising_edge(reset) then
			cnt<=0;
		elsif rising_edge(clk) then
			cnt<=cnt+1;									-- se reinicia la cuenta y se pone a cero la bandera
		end if;
end process;
	
cuenta<=cnt;

end Behavioral;

