entity FIR is 
	generic(
		a0 : integer := 13;
		a1 : integer := 30;
		a2 : integer := 55;
		a3 : integer := 83;
		a4 : integer := 107;
		a5 : integer := 121;
		a6 : integer := 121;
		a7 : integer := 107;
		a8 : integer := 83;
		a9 : integer := 55;
		a10 : integer := 30;
		a11 : integer := 13
	);
	port(
		clk,rst,enable : in std_logic;
		DataIn: in signed (7 downto 0);
		DataOut: out signed(7 downto 0)
	);
end FIR;

architecture filtering of FIR is 

	constant A0s : signed(7 downto 0) := to_signed(a0,8);
	constant A1s : signed(7 downto 0) := to_signed(a1,8);
	constant A2s : signed(7 downto 0) := to_signed(a2,8);
	constant A3s : signed(7 downto 0) := to_signed(a3,8);
	constant A4s : signed(7 downto 0) := to_signed(a4,8);
	constant A5s : signed(7 downto 0) := to_signed(a5,8);
	constant A6s : signed(7 downto 0) := to_signed(a6,8);
	constant A7s : signed(7 downto 0) := to_signed(a7,8);
	constant A8s : signed(7 downto 0) := to_signed(a8,8);
	constant A9s : signed(7 downto 0) := to_signed(a9,8);
	constant A10s : signed(7 downto 0) := to_signed(a10,8);
	constant A11s : signed(7 downto 0) := to_signed(a11,8);

	signal xn0,xn1,xn2,xn3,xn4,xn5,xn6,xn7,xn8,xn9,xn10,xn11 : signed(7 downto 0);

	signal m0,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11 :	signed(15 downto 0);
	signal sum : signed(17 downto 0);
	signal s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11 : signed(17 downto 0);


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

m0 <= xn0*A0s;
m1 <= xn1*A1s;
m2 <= xn2*A2s;
m3 <= xn3*A3s;
m4 <= xn4*A4s;
m5 <= xn5*A5s;
m6 <= xn6*A6s;
m7 <= xn7*A7s;
m8 <= xn8*A8s;
m9 <= xn9*A9s;
m10 <= xn10*A10s;
m11 <= xn11*A11s;

s1 <= resize(m0,18) + resize(m1,18);
s2 <= s1 + resize(m2,18);
s3 <= s2 + resize(m3,18);
s4 <= s3 + resize(m4,18);
s5 <= s4 + resize(m5,18);
s6 <= s5 + resize(m6,18);
s7 <= s6 + resize(m7,18);
s8 <= s7 + resize(m8,18);
s9 <= s8 + resize(m9,18);
s10 <= s9 + resize(m10,18);
sum <= s10 + resize(m11,18);

DataOut <= sum(16 downto 9);
end architecture;