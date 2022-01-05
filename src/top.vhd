library ieee;
use ieee.std_logic_1164.all;



entity top is

  port (

    CLK100MHZ    : in  std_logic;
    uart_txd_in  : in  std_logic;
    uart_rxd_out : out std_logic);

end entity top;

architecture str of top is
  --signal clock        : std_logic;
  signal data_to_send   : std_logic_vector(7 downto 0) := X"61";
  signal fir_out        : std_logic_vector(7 downto 0);
  signal data_valid_in  : std_logic;
  signal data_valid_out : std_logic;
  signal busy           : std_logic;
  --signal uart_tx      : std_logic;
  -- coeff
  signal coeff_0 : std_logic_vector(7 downto 0) := "00000100";
  signal coeff_1 : std_logic_vector(7 downto 0) := "00001111";
  signal coeff_2 : std_logic_vector(7 downto 0) := "00101010";
  signal coeff_3 : std_logic_vector(7 downto 0) := "01000001";
  signal coeff_4 : std_logic_vector(7 downto 0) := "01000001";
  signal coeff_5 : std_logic_vector(7 downto 0) := "00101010";
  signal coeff_6 : std_logic_vector(7 downto 0) := "00001111";
  signal coeff_7 : std_logic_vector(7 downto 0) := "00000100"; 

  component uart_transmitter is
    port (
      clock        : in  std_logic;
      data_to_send : in  std_logic_vector(7 downto 0);
      data_valid   : in  std_logic;
      busy         : out std_logic;
      uart_tx      : out std_logic);
  end component uart_transmitter;

  component uart_receiver is
    port (
      clock         : in  std_logic;
      uart_rx       : in  std_logic;
      valid         : out std_logic;
      received_data : out std_logic_vector(7 downto 0));
  end component uart_receiver;

  component fir_filter_8 is
    port (
  	  i_clk  : in  std_logic;
  	  --i_rstb : in  std_logic;
  	  valid : in std_logic; ---
  	  o_rstb : out std_logic;
  	  -- coeff
  	  i_co_0 : in  std_logic_vector(7 downto 0);
  	  i_co_1 : in  std_logic_vector(7 downto 0);
  	  i_co_2 : in  std_logic_vector(7 downto 0);
  	  i_co_3 : in  std_logic_vector(7 downto 0);
  	  i_co_4 : in  std_logic_vector(7 downto 0);
  	  i_co_5 : in  std_logic_vector(7 downto 0);
  	  i_co_6 : in  std_logic_vector(7 downto 0);
  	  i_co_7 : in  std_logic_vector(7 downto 0);
  	  -- in/out data
  	  i_data : in  std_logic_vector(7 downto 0);
  	  o_data : out std_logic_vector(7 downto 0));
  end component fir_filter_8;
  
begin  -- architecture str

  uart_receiver_1 : uart_receiver
    port map (
      clock         => CLK100MHZ,
      uart_rx       => uart_txd_in,
      valid         => data_valid_in,
      received_data => data_to_send);
      
  uart_transmitter_1 : uart_transmitter
    port map (
      clock        => CLK100MHZ,
      data_to_send => fir_out,
      data_valid   => data_valid_out,
      busy         => busy,
      uart_tx      => uart_rxd_out);
      
  fir_filter : fir_filter_8
    port map (
      i_clk  => CLK100MHZ,
      --i_rstb => data_valid_in,
      valid => data_valid_in,
      o_rstb => data_valid_out,
      -- coeff
      i_co_0 => coeff_0,
      i_co_1 => coeff_1,
      i_co_2 => coeff_2,
      i_co_3 => coeff_3,
      i_co_4 => coeff_4,
      i_co_5 => coeff_5,
      i_co_6 => coeff_6,
      i_co_7 => coeff_7,
      -- in/out data
      i_data => data_to_send,
      o_data => fir_out);

end architecture str;
