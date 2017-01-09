----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:45:20 01/09/2017 
-- Design Name: 
-- Module Name:    decoder - Behavioral 
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

entity decoder is
Port(
	cuenta: in integer range 0 to 9;
	led: out STD_LOGIC_VECTOR(6 downto 0)
);
end decoder;

architecture dataflow of decoder is
begin
 WITH cuenta SELECT
		led <= "0000001" WHEN 0,
				"1001111" WHEN  1,
				"0010010" WHEN  2,
				"0000110" WHEN  3,
				"1001100" WHEN  4,
				"0100100" WHEN  5,
				"0100000" WHEN  6,
				"0001111" WHEN  7,
				"0000000" WHEN  8,
				"0000100" WHEN  9,
				"1111110" WHEN others;

end dataflow;

