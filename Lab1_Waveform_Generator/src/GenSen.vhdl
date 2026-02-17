library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GenSen is 
	port(
		clk: in std_logic;
		rst: in std_logic;
		per: in std_logic_vector(1 downto 0);
		led: out signed(7 downto 0);
		dac: out unsigned(7 downto 0)
	);
end GenSen;

architecture behavioral2 of GenSen is

component rom_sin is 
	port(
		addr : in integer range 0 to 15;
		data_o: out signed(7 downto 0)
	);
end component;

--MUX 
signal maxcount : unsigned(13 downto 0);

--timer
signal cnt_timer : unsigned(13 downto 0);
signal EoCTim : std_logic;

--Counter rom
signal countaddr : unsigned(3 downto 0);
signal addr : integer range 0 to 15;
signal data_o : signed(7 downto 0);

begin
	process(per) --MUX process
		begin
		case per is
			when "00" => maxcount <= to_unsigned(12500,14);
			when "01" => maxcount <= to_unsigned(6250,14);
			when "10" => maxcount <= to_unsigned(2841,14);
			when "11" => maxcount <= to_unsigned(1563,14);
			when others => maxcount <= to_unsigned(12500,14);
		end case;
	end process;
	process(clk,rst) --Timer
		begin
			if rst = '1' then
				cnt_timer <= (others => '0');
			elsif rising_edge(clk) then 
				if cnt_timer >= maxcount then 
					cnt_timer <= (others => '0');
				else
					cnt_timer <= cnt_timer + 1; 
				end if;
			end if;
	end process;
	EoCTim <= '1' when cnt_timer = maxcount else '0';
	process(clk,rst)--ROM Counter
		begin 
			if rst = '1' then
				countaddr <= (others => '0');
			elsif rising_edge(clk) then 
				if EoCTim = '1' then --Enable	
					if countaddr = 15 then 
						countaddr <= (others => '0');
					else
						countaddr <= countaddr + 1; 
					end if;
				end if;
			end if;
	end process;
	
	addr <= to_integer(countaddr);
	
	u_rom : rom_sin port map (addr => addr, data_o =>data_o);
	led <= data_o;
	dac <= unsigned(data_o + to_signed(128,8));
end behavioral2;
	
	
				