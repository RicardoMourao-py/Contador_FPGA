library ieee;
use ieee.std_logic_1164.all;

entity display7Segm is
			 
  port   (
				CLK :  in std_logic;
				Endereco : in  std_logic_vector(7 downto 0);
				Data_OUT      : in  std_logic_vector(3 downto 0);
				Data_Address_5 : in  std_logic;
				Saida_Decoder1_4 : in  std_logic;
				Wr : in  std_logic;
				HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out  std_logic_vector(6 downto 0)
			);
			
end entity;

architecture arquitetura of display7Segm is

	signal Saida_REG0, Saida_REG1, Saida_REG2, Saida_REG3, Saida_REG4, Saida_REG5 : std_logic_vector(3 downto 0);

begin

--- Registradores Genéricos de 4 bits
REG_0 : entity work.registradorGenerico  generic map (larguraDados => 4)
					port map(
						DIN => Data_OUT,
						DOUT => Saida_REG0,
						ENABLE => (Wr and Saida_Decoder1_4 and Data_Address_5 and Endereco(0)),
						CLK => CLK,
						RST => '0'
					);
REG_1 : entity work.registradorGenerico  generic map (larguraDados => 4)
					port map(
						DIN => Data_OUT,
						DOUT => Saida_REG1,
						ENABLE => (Wr and Saida_Decoder1_4 and Data_Address_5 and Endereco(1)),
						CLK => CLK,
						RST => '0'
					);
REG_2 : entity work.registradorGenerico  generic map (larguraDados => 4)
					port map(
						DIN => Data_OUT,
						DOUT => Saida_REG2,
						ENABLE => (Wr and Saida_Decoder1_4 and Data_Address_5 and Endereco(2)),
						CLK => CLK,
						RST => '0'
					);
REG_3 : entity work.registradorGenerico  generic map (larguraDados => 4)
					port map(
						DIN => Data_OUT,
						DOUT => Saida_REG3,
						ENABLE => (Wr and Saida_Decoder1_4 and Data_Address_5 and Endereco(3)),
						CLK => CLK,
						RST => '0'
					);
REG_4 : entity work.registradorGenerico  generic map (larguraDados => 4)
					port map(
						DIN => Data_OUT,
						DOUT => Saida_REG4,
						ENABLE => (Wr and Saida_Decoder1_4 and Data_Address_5 and Endereco(4)),
						CLK => CLK,
						RST => '0'
					);
REG_5 : entity work.registradorGenerico  generic map (larguraDados => 4)
					port map(
						DIN => Data_OUT,
						DOUT => Saida_REG5,
						ENABLE => (Wr and Saida_Decoder1_4 and Data_Address_5 and Endereco(5)),
						CLK => CLK,
						RST => '0'
					);
					
--- Decodificadores Binários de 7 segmentos
DECODER0 :  entity work.conversorHex7Seg
					port map(
						dadoHex => Saida_REG0,
						apaga => '0',
						negativo => '0',
						overFlow => '0',
						saida7seg => HEX0
					);
DECODER1 :  entity work.conversorHex7Seg
					port map(
						dadoHex => Saida_REG1,
						apaga => '0',
						negativo => '0',
						overFlow => '0',
						saida7seg => HEX1
					);
DECODER2 :  entity work.conversorHex7Seg
					port map(
						dadoHex => Saida_REG2,
						apaga => '0',
						negativo => '0',
						overFlow => '0',
						saida7seg => HEX2
					);
DECODER3 :  entity work.conversorHex7Seg
					port map(
						dadoHex => Saida_REG3,
						apaga => '0',
						negativo => '0',
						overFlow => '0',
						saida7seg => HEX3
					);
DECODER4 :  entity work.conversorHex7Seg
					port map(
						dadoHex => Saida_REG4,
						apaga => '0',
						negativo => '0',
						overFlow => '0',
						saida7seg => HEX4
					);
DECODER5 :  entity work.conversorHex7Seg
					port map(
						dadoHex => Saida_REG5,
						apaga => '0',
						negativo => '0',
						overFlow => '0',
						saida7seg => HEX5
					);

end architecture;