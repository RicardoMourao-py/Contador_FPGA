library ieee;
use ieee.std_logic_1164.all;

entity CPU is
  -- Total de bits das entradas e saidas
  generic ( 
		larguraDados : natural := 8;
		larguraEndereco : natural := 9;
		larguraInstru : natural := 13
	 );
  port (
		Wr, Rd : out std_logic;
		Clock, Reset: in std_logic;
		Data_IN : in std_logic_vector(larguraDados-1 downto 0);
		Data_OUT : out std_logic_vector(larguraDados-1 downto 0);
		Data_Address : out std_logic_vector(larguraEndereco-1 downto 0);
		Instruction_IN : in std_logic_vector(larguraInstru-1 downto 0);
		ROM_Address : out std_logic_vector(larguraEndereco-1 downto 0) 
    );
end entity;

architecture comportamento of CPU is
  -- SINAIS CPU ----
  signal CLK : std_logic;
  signal saida_endRetorno : std_logic_vector (larguraEndereco-1 downto 0);
  signal Endereco : std_logic_vector (8 downto 0); 
  signal Sinais_Controle : std_logic_vector (11 downto 0);
  signal proxPC : std_logic_vector (larguraEndereco-1 downto 0);
  signal saidaLogicaDesvio : std_logic_vector (1 downto 0);
  signal saidaFlagIgual : std_logic;
  signal MUX_REG2 : std_logic_vector (larguraDados downto 0);
  signal Saida_ULA : std_logic_vector (larguraDados-1 downto 0);
  signal MUX_REG1 : std_logic_vector (larguraDados-1 downto 0);
  signal REG1_ULA_A : std_logic_vector (larguraDados-1 downto 0);
  signal saida_zero : std_logic;
  
  --- SINAIS DE CONTROLE ---
  signal RET : std_logic;
  signal JSR : std_logic;
  signal habilita_escRetorno : std_logic;
  signal JEQ : std_logic;
  signal JMP : std_logic;
  signal Operacao_ULA : std_logic_vector (1 downto 0);
  signal leituraRAM : std_logic;
  signal escritaRAM : std_logic;
  signal SelMUX : std_logic;
  signal Habilita_A : std_logic; 
  signal HabFlagIgual : std_logic;
  
  --- SINAIS SAIDA ROM/RAM -----
  signal instrucao : std_logic_vector (12 downto 0);
  signal saida_RAM: std_logic_vector (larguraDados-1 downto 0);
  
  begin
   -- O port map completo do MUX.
	MUX1 :  entity work.muxGenerico2x1  generic map (larguraDados => larguraDados)
			  port map( entradaA_MUX => Saida_RAM,
						  entradaB_MUX =>  instrucao(7 downto 0),
						  seletor_MUX => SelMUX,
						  saida_MUX => MUX_REG1);
						  
	MUX2 :  entity work.muxGenerico4x1  generic map (larguraDados => 9)
			  port map( entradaA_MUX => proxPC,
						  entradaB_MUX =>  instrucao(8 downto 0),
						  entradaC_MUX => saida_endRetorno,
						  entradaD_MUX =>  "000000000",
						  seletor_MUX => saidaLogicaDesvio,
						  saida_MUX => MUX_REG2);
	-- O port map completo do Acumulador.
	REGA : entity work.registradorGenerico   generic map (larguraDados => larguraDados)
				 port map (DIN => Saida_ULA, DOUT => REG1_ULA_A, ENABLE => Habilita_A, CLK => Clock, RST => '0');

	FlagIgual : entity work.FlipFlop 
				 port map (DIN => saida_zero, DOUT => saidaFlagIgual, ENABLE => HabFlagIgual, CLK => Clock, RST => '0');

	ENDERECO_RETORNO : entity work.enderecoRetorno   generic map (larguraDados => 9)
							port map (DIN => proxPC, DOUT => saida_endRetorno, ENABLE => habilita_escRetorno, CLK => Clock, RST => '0');
				 
	-- O port map completo do Program Counter.
	PC : entity work.registradorGenerico   generic map (larguraDados => larguraEndereco)
				 port map (DIN => MUX_REG2, DOUT => Endereco, ENABLE => '1', CLK => Clock, RST => '0');

	incrementaPC :  entity work.somaConstante  generic map (larguraDados => larguraEndereco, constante => 1)
			  port map( entrada => Endereco, saida => proxPC);


	-- O port map completo da ULA:
	ULA1 : entity work.ULASomaSub  generic map(larguraDados => larguraDados)
				 port map (entradaA => REG1_ULA_A, entradaB => MUX_REG1, saida => Saida_ULA, flagZero => 
				 saida_zero, seletor => Operacao_ULA);
	
	-- Falta acertar o conteudo da ROM (no arquivo memoriaROM.vhd)
	DECODE1 : entity work.decoderInstru port map (opcode => instrucao(12 downto 9), saida => Sinais_Controle);
	
	LOGICA_DESVIO: entity work.logicaDesvio
					port map(JMP => JMP, RET => RET, JSR => JSR, JEQ => JEQ, Flag => saidaFlagIgual, 
								saida_Desvio => saidaLogicaDesvio);
	
	habilita_escRetorno <= Sinais_Controle(11);
	JMP <= Sinais_Controle(10);
	RET <= Sinais_Controle(9);
	JSR <= Sinais_Controle(8);
	JEQ <= Sinais_Controle(7);
	selMUX <= Sinais_Controle(6);
	Habilita_A <= Sinais_Controle(5);
	Operacao_ULA <= Sinais_Controle(4 downto 3);
	HabFlagIgual <= Sinais_Controle(2);
	leituraRAM <= Sinais_Controle(1);
	escritaRAM <= Sinais_Controle(0);

	Wr              <= escritaRAM;
	Rd              <= leituraRAM;
	ROM_Address     <= Endereco;
	instrucao       <= Instruction_IN;
	saida_RAM       <= Data_IN;
	Data_OUT        <= REG1_ULA_A;
	Data_Address    <= instrucao(8 downto 0);
	
end architecture;
