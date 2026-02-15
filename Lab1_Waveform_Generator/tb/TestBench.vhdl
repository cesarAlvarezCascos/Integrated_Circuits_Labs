library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity tb is 
end tb;

architecture Prueba1 of tb is 

component GenSen is 
	port(
		clk: in std_logic;
		rst: in std_logic;
		per: in std_logic_vector(1 downto 0);
		led: out signed(7 downto 0);
		dac: out unsigned(7 downto 0)
	);
end component;

signal clk : std_logic;
signal rst : std_logic;
signal per : std_logic_vector(1 downto 0);
signal led : signed(7 downto 0);
signal dac : unsigned(7 downto 0);

constant T : time := 10 ns;

begin
DUT : GenSen port map (clk => clk,rst => rst,per => per, led => led, dac => dac);
	process
		begin 
			clk <= '0';
			wait for T/2;
			clk <= '1';
			wait for T/2;
	end process;

	process 
		begin
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		
		per <= "00";
		wait for 4 ms;

		per <= "01";
		wait for 2 ms;

		per <= "10";
		wait for 1 ms;   

		per <= "11";
		wait for 0.5 ms;
		
		per <= "00";
		wait;
		
	end process;
end Prueba1;
		
