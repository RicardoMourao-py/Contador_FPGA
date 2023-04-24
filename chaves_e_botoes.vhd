library ieee;
use ieee.std_logic_1164.all;

entity chaves_e_botoes is
			 
  port   (
				Rd : in  std_logic;
				Data_Address_5 : in  std_logic;
				Endereco : in  std_logic_vector(4 downto 0);
				Saida_Decoder1_5 : in  std_logic;
				KEY0, KEY1, KEY2, KEY3, FPGA_RESET : in  std_logic;
				SW       : in  std_logic_vector(9 downto 0);
				Data_IN      : out  std_logic_vector(7 downto 0)
			);
			
end entity;

architecture arquitetura of chaves_e_botoes is

begin

--- Chaves
tristate_SW0a7 :  entity work.buffer_3_state_8portas
							port map(
										entrada => SW(7 downto 0), 
										habilita =>  (Rd and not(Data_Address_5) and Endereco(0) and Saida_Decoder1_5), 
										saida => Data_IN
										);
tristate_SW8 :  entity work.buffer_3_state_8portas
							port map(
										entrada => "0000000" & SW(8), 
										habilita =>  (Rd and not(Data_Address_5) and Endereco(1) and Saida_Decoder1_5), 
										saida => Data_IN
										);
tristate_SW9 :  entity work.buffer_3_state_8portas
							port map(
										entrada => "0000000" & SW(9), 
										habilita =>  (Rd and not(Data_Address_5) and Endereco(2) and Saida_Decoder1_5), 
										saida => Data_IN
										);
--- Botoes
--tristate_Key0 :  entity work.buffer_3_state_8portas
--							port map(
--										entrada => "0000000" & KEY0, 
--										habilita =>  (Rd and Data_Address_5 and Endereco(0) and Saida_Decoder1_5), 
--										saida => Data_IN
--										);
tristate_Key1 :  entity work.buffer_3_state_8portas
							port map(
										entrada => "0000000" & KEY1, 
										habilita =>  (Rd and Data_Address_5 and Endereco(1) and Saida_Decoder1_5), 
										saida => Data_IN
										);
tristate_Key2 :  entity work.buffer_3_state_8portas
							port map(
										entrada => "0000000" & KEY2, 
										habilita =>  (Rd and Data_Address_5 and Endereco(2) and Saida_Decoder1_5), 
										saida => Data_IN
										);
tristate_Key3 :  entity work.buffer_3_state_8portas
							port map(
										entrada => "0000000" & KEY3, 
										habilita =>  (Rd and Data_Address_5 and Endereco(3) and Saida_Decoder1_5), 
										saida => Data_IN
										);
tristate_FPGA :  entity work.buffer_3_state_8portas
							port map(
										entrada => "0000000" & FPGA_RESET, 
										habilita =>  (Rd and Data_Address_5 and Endereco(4) and Saida_Decoder1_5), 
										saida => Data_IN
										);
end architecture;