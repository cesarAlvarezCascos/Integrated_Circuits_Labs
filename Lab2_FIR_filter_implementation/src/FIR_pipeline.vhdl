library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIR_pipeline is 
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
end FIR_pipeline;

architecture filtering of FIR_pipeline is 

    constant A0s : signed(7 downto 0) := to_signed(a0,8);
    constant A1s : signed(7 downto 0) := to_signed(a1,8);
    constant A2s : signed(7 downto 0) := to_signed(a2,8);
    constant A3s : signed(7 downto 0) := to_signed(a3,8);
    constant A4s : signed(7 downto 0) := to_signed(a4,8);
    constant A5s : signed(7 downto 0) := to_signed(a5,8);

    signal xn0,xn1,xn2,xn3,xn4,xn5,xn6,xn7,xn8,xn9,xn10,xn11 : signed(7 downto 0);

    signal s1,s2,s3,s4,s5,s6 : signed(8 downto 0);

    signal m0,m1,m2,m3,m4,m5 : signed(16 downto 0);

    signal s7,s8,s9 : signed(17 downto 0);


    signal sum : signed(17 downto 0);

begin


process(clk,rst)
begin
    if rst='1' then
        xn0 <= (others=>'0'); 
		xn1 <= (others=>'0');
        xn2 <= (others=>'0'); 
		xn3 <= (others=>'0');
        xn4 <= (others=>'0'); 
		xn5 <= (others=>'0');
        xn6 <= (others=>'0'); 
		xn7 <= (others=>'0');
        xn8 <= (others=>'0'); 
		xn9 <= (others=>'0');
        xn10 <= (others=>'0'); 
		xn11 <= (others=>'0');
    elsif rising_edge(clk) then
        if enable='1' then
            xn0 <= DataIn;
            xn1 <= xn0;
            xn2 <= xn1;
            xn3 <= xn2;
            xn4 <= xn3;
            xn5 <= xn4;
            xn6 <= xn5;
            xn7 <= xn6;
            xn8 <= xn7;
            xn9 <= xn8;
            xn10 <= xn9;
            xn11 <= xn10;
        end if;
    end if;
end process;


process(clk,rst)
begin
    if rst='1' then
        s1 <= (others=>'0'); 
		s2 <= (others=>'0');
        s3 <= (others=>'0'); 
		s4 <= (others=>'0');
        s5 <= (others=>'0'); 
		s6 <= (others=>'0');
    elsif rising_edge(clk) then
        if enable='1' then
            s1 <= resize(xn0,9)  + resize(xn11,9);
            s2 <= resize(xn1,9)  + resize(xn10,9);
            s3 <= resize(xn2,9)  + resize(xn9,9);
            s4 <= resize(xn3,9)  + resize(xn8,9);
            s5 <= resize(xn4,9)  + resize(xn7,9);
            s6 <= resize(xn5,9)  + resize(xn6,9);
        end if;
    end if;
end process;

process(clk,rst)
begin
    if rst='1' then
        m0 <= (others=>'0'); 
		m1 <= (others=>'0');
        m2 <= (others=>'0'); 
		m3 <= (others=>'0');
        m4 <= (others=>'0'); 
		m5 <= (others=>'0');
    elsif rising_edge(clk) then
        if enable='1' then
            m0 <= s1 * A0s;
            m1 <= s2 * A1s;
            m2 <= s3 * A2s;
            m3 <= s4 * A3s;
            m4 <= s5 * A4s;
            m5 <= s6 * A5s;
        end if;
    end if;
end process;


process(clk,rst)
begin
    if rst='1' then
        s7 <= (others=>'0');
        s8 <= (others=>'0');
        s9 <= (others=>'0');
    elsif rising_edge(clk) then
        if enable='1' then
            s7 <= resize(m0,18) + resize(m1,18);
            s8 <= resize(m2,18) + resize(m3,18);
            s9 <= resize(m4,18) + resize(m5,18);
        end if;
    end if;
end process;


process(clk,rst)
begin
    if rst='1' then
        sum <= (others=>'0');
    elsif rising_edge(clk) then
        if enable='1' then
            sum <= s7 + s8 + s9;
        end if;
    end if;
end process;


process(clk,rst)
begin
    if rst='1' then
        DataOut <= (others=>'0');
    elsif rising_edge(clk) then
        if enable='1' then
            DataOut <= resize(shift_right(sum,8),8);
        end if;
    end if;
end process;

end filtering;