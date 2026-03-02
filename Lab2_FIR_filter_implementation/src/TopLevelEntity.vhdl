library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP is 
port(
    clk : in std_logic;
    rst : in std_logic;
    per : in std_logic_vector(1 downto 0);

    led : out signed(7 downto 0);
    dac : out unsigned(7 downto 0)
);
end TOP;

architecture topLevel of TOP is 

component GenSen is 
port(
    clk: in std_logic;
    rst: in std_logic;
    per: in std_logic_vector(1 downto 0);
    led: out signed(7 downto 0);
    dac: out unsigned(7 downto 0)
);
end component;

component FIR is 
	 generic(
        a0 : integer := -8;
        a1 : integer := -14;
        a2 : integer := -1;
        a3 : integer := 20;
        a4 : integer := 52;
        a5 : integer := 73
    );
    port(
        clk     : in std_logic;
        rst     : in std_logic;
        enable  : in std_logic;
        DataIn  : in signed (7 downto 0);
        DataOut : out signed(7 downto 0)
    );
end component;

signal sine_data : signed(7 downto 0);
signal fir_data  : signed(7 downto 0);

signal cnt_10k : unsigned(13 downto 0);
signal enable10k : std_logic;

begin


Gen1 : GenSen
port map(
 clk => clk,
 rst => rst,
 per => per,
 led => sine_data,
 dac => open
);

process(clk,rst)
begin
    if rst='1' then
        cnt_10k <= (others=>'0');

    elsif rising_edge(clk) then

        if cnt_10k = 9999 then
            cnt_10k <= (others=>'0');
        else
            cnt_10k <= cnt_10k + 1;
        end if;

    end if;
end process;

enable10k <= '1' when cnt_10k=9999 else '0';


FIR1 : FIR_pipeline
port map(
 clk => clk,
 rst => rst,
 enable => enable10k,
 DataIn => sine_data,
 DataOut => fir_data
);

led <= fir_data;

dac <= unsigned(fir_data + to_signed(128,8));

end topLevel;