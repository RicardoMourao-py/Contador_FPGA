library ieee;
use ieee.std_logic_1164.all;

entity Contador is
  -- Total de bits das entradas e saidas
  generic ( 
				larguraDados : natural := 8;
				larguraEndereco : natural := 9;
				larguraInstru : natural := 13;
				simulacao : boolean := FALSE -- para gravar na placa, altere de TRUE para FALSE
			 );
			 
  port   (
				CLOCK_50 : in  std_logic;
				KEY      : in  std_logic_vector(3 downto 0);
				FPGA_RESET_N : in  std_logic;
				SW       : in  std_logic_vector(9 downto 0);
				LEDR     : out std_logic_vector(9 downto 0);
				HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out  std_logic_vector(6 downto 0)
			);
end entity;


architecture arquitetura of Contador is

	-- Sinais de Enderaçamento da RAM
	signal ROM_Address       :   std_logic_vector(larguraEndereco-1 downto 0);
	signal Data_OUT          :   std_logic_vector(larguraDados-1 downto 0);
	signal Data_Address      :   std_logic_vector(larguraEndereco-1 downto 0);
	signal Data_IN           :   std_logic_vector(larguraDados-1 downto 0);
	signal Wr                :   std_logic;
	signal Rd                :   std_logic;
	signal Instruction_IN    :   std_logic_vector(larguraInstru-1 downto 0);
	signal Saida_Decoder1    :   std_logic_vector(7 downto 0);
	signal CLK               :   std_logic;
	signal Rst               :   std_logic;
	-- Sinais de Enderaçamento dos LED's
	signal Saida_Decoder2    :   std_logic_vector(7 downto 0);
	
begin

-- Instanciando os componentes:

-- Para simular, fica mais simples tirar o edgeDetector
--gravar:  if simulacao generate
--CLK <= KEY(0);
--else generate
--detectorSub0: work.edgeDetector(bordaSubida)
--        port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => CLK);
--end generate;

CLK <= CLOCK_50;

-- O port map completo da CPU.
CPU :  entity work.CPU  
        port map( Wr => Wr, 
						Rd => Rd,
						Clock => CLK, 
						Reset => '0',
						Data_IN => Data_IN,
						Data_OUT => Data_OUT,
						Data_Address => Data_Address,
						Instruction_IN => Instruction_IN,
						ROM_Address => ROM_Address
					  );
					  
-- Modulos necessários para endereçamento da RAM -----------------------------------------

-- Falta acertar o conteudo da ROM (no arquivo memoriaROM.vhd)
ROM1 : entity work.memoriaROM   generic map (dataWidth => 13, addrWidth => 9)
          port map (Endereco => ROM_Address, Dado => Instruction_IN);

-- Falta acertar o conteudo da RAM (no arquivo memoriaRAM.vhd)
RAM1: entity work.memoriaRAM  
          port map (	
							addr=> Data_Address(5 downto 0), 
							we=> Wr, 
							re=> Rd,  
							habilita=> Saida_Decoder1(0),      
							clk=> CLK,
							dado_in=> Data_OUT,
							dado_out=> Data_IN
						 );

decodifica3x8_1: entity work.decodificador3x8
						port map (	
							entrada=> Data_Address(8 downto 6), 
							saida=> Saida_Decoder1
	
					 );

-- Modulos necessários para endereçamento dos LED's --------------------------------
decodifica3x8_2: entity work.decodificador3x8
						port map (	
							entrada=> Data_Address(2 downto 0), 
							saida=> Saida_Decoder2
						 );
						 
ControlaLeds: entity work.controlaLeds
						port map (	
							Saida_Decoder1 => Saida_Decoder1, Saida_Decoder2 => Saida_Decoder2,
							Data_Address => Data_Address,
							Data_OUT =>Data_OUT,
							LEDR => LEDR,
							Wr=>Wr,
							CLK=>CLK
						 );

-- Modulo dos displays de 7 segmentos -----------------------------------------------
Displays : entity work.display7Segm
					port map(
					   CLK => CLK,
						Endereco => Saida_Decoder2,
						Data_OUT => Data_OUT(3 downto 0),
						Data_Address_5 => Data_Address(5),
						Saida_Decoder1_4 => Saida_Decoder1(4),
						Wr => Wr,
						HEX0=>HEX0, HEX1=>HEX1, HEX2=>HEX2, HEX3=>HEX3, HEX4=>HEX4, HEX5=>HEX5
					);
-- Modulo de chaves e botoes ----------------------------------------------------------
Chaves_e_Botoes: entity work.chaves_e_botoes
							port map(
								Rd => Rd,
								Data_Address_5 => Data_Address(5),
								Endereco => Saida_Decoder2(4 downto 0),
								Saida_Decoder1_5 => Saida_Decoder1(5),
								KEY0=>KEY(0), KEY1=>KEY(1), KEY2=>KEY(2), KEY3=>KEY(3), FPGA_RESET=>FPGA_RESET_N,
								SW => SW,
								Data_IN => Data_IN
							);
-- Tratamento espcial para KEY0 e KEY1 ----------------------------------------------------
Debounce: entity work.debounce_memoriza 
					port map (
						CLK_50 => CLOCK_50,
						Addr => Data_Address,
						WR => Wr,
						KEY0 => KEY(0),
						HabilitaLeituraKey0 => (Rd and Data_Address(5) and Saida_Decoder2(0) and Saida_Decoder1(5)),
						leituraKey0 => Data_IN
					);
end architecture;