library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rom_sin is 
	port(
		addr : in integer range 0 to 15;
		data_o: out signed(7 downto 0)
	);
end rom_sin;

architecture behavioral of rom_sin is 
	type rom_t is array (0 to 15) of signed(7 downto 0);
	constant rom: rom_t := (
	0  => to_signed(0,   8),
    1  => to_signed(49,  8),
    2  => to_signed(90,  8),
    3  => to_signed(117, 8),
    4  => to_signed(127, 8),
    5  => to_signed(117, 8),
    6  => to_signed(90,  8),
    7  => to_signed(49,  8),
    8  => to_signed(0,   8),
    9  => to_signed(-49, 8),
    10 => to_signed(-90, 8),
    11 => to_signed(-117,8),
    12 => to_signed(-127,8),
    13 => to_signed(-117,8),
    14 => to_signed(-90, 8),
    15 => to_signed(-49, 8)
	);
begin 
	data_o <= rom(addr);
end behavioral;