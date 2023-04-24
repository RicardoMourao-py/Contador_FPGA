library ieee;
use ieee.std_logic_1164.all;

entity controlaLeds is
  port   (
				Saida_Decoder1, Saida_Decoder2 : in std_logic_vector(7 downto 0);
				Data_Address : in std_logic_vector(8 downto 0);
				Data_OUT : in std_logic_vector(7 downto 0);
				LEDR : out std_logic_vector(9 downto 0);
				Wr : in std_logic;
				CLK : in std_logic
			);
end entity;

architecture arquitetura of controlaLeds is

begin
--- LEDR0 até LEDR7 --- bit 0
LEDR_0a7 : entity work.registradorGenerico  generic map (larguraDados => 8)
					port map(
						DIN => Data_OUT,
						DOUT => LEDR(7 downto 0),
						ENABLE => (Wr and Saida_Decoder2(0) and Saida_Decoder1(4) and not(Data_Address(5))),
						CLK => CLK,
						RST => '0'
					);

--- Para escrita --- bit 1
LEDR8 : entity work.FlipFlop
	port map(
		DIN => Data_OUT(0),
		DOUT => LEDR(8),
		ENABLE => (Wr and Saida_Decoder2(1) and Saida_Decoder1(4) and not(Data_Address(5))),
		CLK => CLK,
		RST => '0'
	);
	
--- Para escrita --- bit 2
LEDR9 : entity work.FlipFlop
	port map(
		DIN => Data_OUT(0),
		DOUT => LEDR(9),
		ENABLE => (Wr and Saida_Decoder2(2) and Saida_Decoder1(4) and not(Data_Address(5))),
		CLK => CLK,
		RST => '0'
	);
end architecture;