library ieee;
use ieee.std_logic_1164.all;

entity debounce_memoriza is
  port   (
    CLK_50 : in std_logic;
    Addr: in std_logic_vector(8 downto 0);
    WR: in std_logic;
    KEY0: in std_logic;
    HabilitaLeituraKey0: in std_logic;
    leituraKey0 : out std_logic_vector(7 downto 0)
  );
end entity;

architecture arquitetura of debounce_memoriza is

	signal saida_key0: std_logic_vector(7 downto 0);
	signal saida_ff_Key0: std_logic;
	signal limpaLeituraKey0: std_logic;
	signal SaidaDetectorKey0: std_logic;
	signal EntradaTristate: std_logic_vector(7 downto 0);

begin

detectorKey0: work.edgeDetector(bordaSubida)
              port map (clk => CLK_50, entrada => not(KEY0), saida => SaidaDetectorKey0);

limpaLeituraKey0 <= WR and Addr(8) and Addr(7) and Addr(6) and Addr(5) and Addr(4) and Addr(3) and Addr(2) and Addr(1) and Addr(0);

FF_key : entity work.FlipFlop
         port map (DIN =>  '1',
                   DOUT => saida_ff_Key0, 
                   ENABLE => '1', 
                   CLK => SaidaDetectorKey0, 
                   RST => limpaLeituraKey0);

EntradaTristate <= "0000000" & saida_ff_Key0;


TristateBuffer: entity work.buffer_3_state_8portas
						port map(
							entrada => EntradaTristate, 
							habilita => HabilitaLeituraKey0, 
							saida => saida_key0
						);

leituraKey0 <= saida_key0;

end architecture;