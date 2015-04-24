---------------------------------------------------------------------------------------
-- Title          : Wishbone slave core for Wishbone SERDES clock generator
---------------------------------------------------------------------------------------
-- File           : serdes_clk_gen_regs.vhd
-- Author         : auto-generated by wbgen2 from serdes_clk_gen_regs.wb
-- Created        : Mon Apr 20 11:31:16 2015
-- Standard       : VHDL'87
---------------------------------------------------------------------------------------
-- THIS FILE WAS GENERATED BY wbgen2 FROM SOURCE FILE serdes_clk_gen_regs.wb
-- DO NOT HAND-EDIT UNLESS IT'S ABSOLUTELY NECESSARY!
---------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serdes_clk_gen_regs is
  port (
    rst_n_i                                  : in     std_logic;
    clk_sys_i                                : in     std_logic;
    wb_adr_i                                 : in     std_logic_vector(2 downto 0);
    wb_dat_i                                 : in     std_logic_vector(31 downto 0);
    wb_dat_o                                 : out    std_logic_vector(31 downto 0);
    wb_cyc_i                                 : in     std_logic;
    wb_sel_i                                 : in     std_logic_vector(3 downto 0);
    wb_stb_i                                 : in     std_logic;
    wb_we_i                                  : in     std_logic;
    wb_ack_o                                 : out    std_logic;
    wb_stall_o                               : out    std_logic;
    clk_ref_i                                : in     std_logic;
-- Port for std_logic_vector field: 'Channel select bits' in reg: 'CHSELR'
    reg_chsel_o                              : out    std_logic_vector(31 downto 0);
-- Ports for asynchronous (clock: clk_ref_i) std_logic_vector field: 'Bits of currently selected banked register' in reg: 'PERR'
    reg_per_o                                : out    std_logic_vector(31 downto 0);
    reg_per_i                                : in     std_logic_vector(31 downto 0);
    reg_per_load_o                           : out    std_logic;
-- Ports for asynchronous (clock: clk_ref_i) std_logic_vector field: 'Bits of currently selected banked register' in reg: 'PERHIR'
    reg_perhi_o                              : out    std_logic_vector(31 downto 0);
    reg_perhi_i                              : in     std_logic_vector(31 downto 0);
    reg_perhi_load_o                         : out    std_logic;
-- Ports for asynchronous (clock: clk_ref_i) std_logic_vector field: 'Bits of currently selected banked register' in reg: 'FRACR'
    reg_frac_o                               : out    std_logic_vector(31 downto 0);
    reg_frac_i                               : in     std_logic_vector(31 downto 0);
    reg_frac_load_o                          : out    std_logic;
-- Ports for asynchronous (clock: clk_ref_i) std_logic_vector field: 'Bits of currently selected banked register' in reg: 'MASKR'
    reg_mask_o                               : out    std_logic_vector(31 downto 0);
    reg_mask_i                               : in     std_logic_vector(31 downto 0);
    reg_mask_load_o                          : out    std_logic;
-- Ports for asynchronous (clock: clk_ref_i) std_logic_vector field: 'Bits of currently selected banked register' in reg: 'PHOFSLR'
    reg_phofsl_o                             : out    std_logic_vector(31 downto 0);
    reg_phofsl_i                             : in     std_logic_vector(31 downto 0);
    reg_phofsl_load_o                        : out    std_logic;
-- Ports for asynchronous (clock: clk_ref_i) std_logic_vector field: 'Bits of currently selected banked register' in reg: 'PHOFSHR'
    reg_phofsh_o                             : out    std_logic_vector(31 downto 0);
    reg_phofsh_i                             : in     std_logic_vector(31 downto 0);
    reg_phofsh_load_o                        : out    std_logic
  );
end serdes_clk_gen_regs;

architecture syn of serdes_clk_gen_regs is

signal reg_chsel_int                            : std_logic_vector(31 downto 0);
signal reg_per_int_read                         : std_logic_vector(31 downto 0);
signal reg_per_int_write                        : std_logic_vector(31 downto 0);
signal reg_per_lw                               : std_logic      ;
signal reg_per_lw_delay                         : std_logic      ;
signal reg_per_lw_read_in_progress              : std_logic      ;
signal reg_per_lw_s0                            : std_logic      ;
signal reg_per_lw_s1                            : std_logic      ;
signal reg_per_lw_s2                            : std_logic      ;
signal reg_per_rwsel                            : std_logic      ;
signal reg_perhi_int_read                       : std_logic_vector(31 downto 0);
signal reg_perhi_int_write                      : std_logic_vector(31 downto 0);
signal reg_perhi_lw                             : std_logic      ;
signal reg_perhi_lw_delay                       : std_logic      ;
signal reg_perhi_lw_read_in_progress            : std_logic      ;
signal reg_perhi_lw_s0                          : std_logic      ;
signal reg_perhi_lw_s1                          : std_logic      ;
signal reg_perhi_lw_s2                          : std_logic      ;
signal reg_perhi_rwsel                          : std_logic      ;
signal reg_frac_int_read                        : std_logic_vector(31 downto 0);
signal reg_frac_int_write                       : std_logic_vector(31 downto 0);
signal reg_frac_lw                              : std_logic      ;
signal reg_frac_lw_delay                        : std_logic      ;
signal reg_frac_lw_read_in_progress             : std_logic      ;
signal reg_frac_lw_s0                           : std_logic      ;
signal reg_frac_lw_s1                           : std_logic      ;
signal reg_frac_lw_s2                           : std_logic      ;
signal reg_frac_rwsel                           : std_logic      ;
signal reg_mask_int_read                        : std_logic_vector(31 downto 0);
signal reg_mask_int_write                       : std_logic_vector(31 downto 0);
signal reg_mask_lw                              : std_logic      ;
signal reg_mask_lw_delay                        : std_logic      ;
signal reg_mask_lw_read_in_progress             : std_logic      ;
signal reg_mask_lw_s0                           : std_logic      ;
signal reg_mask_lw_s1                           : std_logic      ;
signal reg_mask_lw_s2                           : std_logic      ;
signal reg_mask_rwsel                           : std_logic      ;
signal reg_phofsl_int_read                      : std_logic_vector(31 downto 0);
signal reg_phofsl_int_write                     : std_logic_vector(31 downto 0);
signal reg_phofsl_lw                            : std_logic      ;
signal reg_phofsl_lw_delay                      : std_logic      ;
signal reg_phofsl_lw_read_in_progress           : std_logic      ;
signal reg_phofsl_lw_s0                         : std_logic      ;
signal reg_phofsl_lw_s1                         : std_logic      ;
signal reg_phofsl_lw_s2                         : std_logic      ;
signal reg_phofsl_rwsel                         : std_logic      ;
signal reg_phofsh_int_read                      : std_logic_vector(31 downto 0);
signal reg_phofsh_int_write                     : std_logic_vector(31 downto 0);
signal reg_phofsh_lw                            : std_logic      ;
signal reg_phofsh_lw_delay                      : std_logic      ;
signal reg_phofsh_lw_read_in_progress           : std_logic      ;
signal reg_phofsh_lw_s0                         : std_logic      ;
signal reg_phofsh_lw_s1                         : std_logic      ;
signal reg_phofsh_lw_s2                         : std_logic      ;
signal reg_phofsh_rwsel                         : std_logic      ;
signal ack_sreg                                 : std_logic_vector(9 downto 0);
signal rddata_reg                               : std_logic_vector(31 downto 0);
signal wrdata_reg                               : std_logic_vector(31 downto 0);
signal bwsel_reg                                : std_logic_vector(3 downto 0);
signal rwaddr_reg                               : std_logic_vector(2 downto 0);
signal ack_in_progress                          : std_logic      ;
signal wr_int                                   : std_logic      ;
signal rd_int                                   : std_logic      ;
signal allones                                  : std_logic_vector(31 downto 0);
signal allzeros                                 : std_logic_vector(31 downto 0);

begin
-- Some internal signals assignments. For (foreseen) compatibility with other bus standards.
  wrdata_reg <= wb_dat_i;
  bwsel_reg <= wb_sel_i;
  rd_int <= wb_cyc_i and (wb_stb_i and (not wb_we_i));
  wr_int <= wb_cyc_i and (wb_stb_i and wb_we_i);
  allones <= (others => '1');
  allzeros <= (others => '0');
-- 
-- Main register bank access process.
  process (clk_sys_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      ack_sreg <= "0000000000";
      ack_in_progress <= '0';
      rddata_reg <= "00000000000000000000000000000000";
      reg_chsel_int <= "00000000000000000000000000000000";
      reg_per_lw <= '0';
      reg_per_lw_delay <= '0';
      reg_per_lw_read_in_progress <= '0';
      reg_per_rwsel <= '0';
      reg_per_int_write <= "00000000000000000000000000000000";
      reg_perhi_lw <= '0';
      reg_perhi_lw_delay <= '0';
      reg_perhi_lw_read_in_progress <= '0';
      reg_perhi_rwsel <= '0';
      reg_perhi_int_write <= "00000000000000000000000000000000";
      reg_frac_lw <= '0';
      reg_frac_lw_delay <= '0';
      reg_frac_lw_read_in_progress <= '0';
      reg_frac_rwsel <= '0';
      reg_frac_int_write <= "00000000000000000000000000000000";
      reg_mask_lw <= '0';
      reg_mask_lw_delay <= '0';
      reg_mask_lw_read_in_progress <= '0';
      reg_mask_rwsel <= '0';
      reg_mask_int_write <= "00000000000000000000000000000000";
      reg_phofsl_lw <= '0';
      reg_phofsl_lw_delay <= '0';
      reg_phofsl_lw_read_in_progress <= '0';
      reg_phofsl_rwsel <= '0';
      reg_phofsl_int_write <= "00000000000000000000000000000000";
      reg_phofsh_lw <= '0';
      reg_phofsh_lw_delay <= '0';
      reg_phofsh_lw_read_in_progress <= '0';
      reg_phofsh_rwsel <= '0';
      reg_phofsh_int_write <= "00000000000000000000000000000000";
    elsif rising_edge(clk_sys_i) then
-- advance the ACK generator shift register
      ack_sreg(8 downto 0) <= ack_sreg(9 downto 1);
      ack_sreg(9) <= '0';
      if (ack_in_progress = '1') then
        if (ack_sreg(0) = '1') then
          ack_in_progress <= '0';
        else
          reg_per_lw <= reg_per_lw_delay;
          reg_per_lw_delay <= '0';
          if ((ack_sreg(1) = '1') and (reg_per_lw_read_in_progress = '1')) then
            rddata_reg(31 downto 0) <= reg_per_int_read;
            reg_per_lw_read_in_progress <= '0';
          end if;
          reg_perhi_lw <= reg_perhi_lw_delay;
          reg_perhi_lw_delay <= '0';
          if ((ack_sreg(1) = '1') and (reg_perhi_lw_read_in_progress = '1')) then
            rddata_reg(31 downto 0) <= reg_perhi_int_read;
            reg_perhi_lw_read_in_progress <= '0';
          end if;
          reg_frac_lw <= reg_frac_lw_delay;
          reg_frac_lw_delay <= '0';
          if ((ack_sreg(1) = '1') and (reg_frac_lw_read_in_progress = '1')) then
            rddata_reg(31 downto 0) <= reg_frac_int_read;
            reg_frac_lw_read_in_progress <= '0';
          end if;
          reg_mask_lw <= reg_mask_lw_delay;
          reg_mask_lw_delay <= '0';
          if ((ack_sreg(1) = '1') and (reg_mask_lw_read_in_progress = '1')) then
            rddata_reg(31 downto 0) <= reg_mask_int_read;
            reg_mask_lw_read_in_progress <= '0';
          end if;
          reg_phofsl_lw <= reg_phofsl_lw_delay;
          reg_phofsl_lw_delay <= '0';
          if ((ack_sreg(1) = '1') and (reg_phofsl_lw_read_in_progress = '1')) then
            rddata_reg(31 downto 0) <= reg_phofsl_int_read;
            reg_phofsl_lw_read_in_progress <= '0';
          end if;
          reg_phofsh_lw <= reg_phofsh_lw_delay;
          reg_phofsh_lw_delay <= '0';
          if ((ack_sreg(1) = '1') and (reg_phofsh_lw_read_in_progress = '1')) then
            rddata_reg(31 downto 0) <= reg_phofsh_int_read;
            reg_phofsh_lw_read_in_progress <= '0';
          end if;
        end if;
      else
        if ((wb_cyc_i = '1') and (wb_stb_i = '1')) then
          case rwaddr_reg(2 downto 0) is
          when "000" => 
            if (wb_we_i = '1') then
              reg_chsel_int <= wrdata_reg(31 downto 0);
            end if;
            rddata_reg(31 downto 0) <= reg_chsel_int;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "001" => 
            if (wb_we_i = '1') then
              reg_per_int_write <= wrdata_reg(31 downto 0);
              reg_per_lw <= '1';
              reg_per_lw_delay <= '1';
              reg_per_lw_read_in_progress <= '0';
              reg_per_rwsel <= '1';
            end if;
            if (wb_we_i = '0') then
              reg_per_lw <= '1';
              reg_per_lw_delay <= '1';
              reg_per_lw_read_in_progress <= '1';
              reg_per_rwsel <= '0';
            end if;
            ack_sreg(5) <= '1';
            ack_in_progress <= '1';
          when "010" => 
            if (wb_we_i = '1') then
              reg_perhi_int_write <= wrdata_reg(31 downto 0);
              reg_perhi_lw <= '1';
              reg_perhi_lw_delay <= '1';
              reg_perhi_lw_read_in_progress <= '0';
              reg_perhi_rwsel <= '1';
            end if;
            if (wb_we_i = '0') then
              reg_perhi_lw <= '1';
              reg_perhi_lw_delay <= '1';
              reg_perhi_lw_read_in_progress <= '1';
              reg_perhi_rwsel <= '0';
            end if;
            ack_sreg(5) <= '1';
            ack_in_progress <= '1';
          when "011" => 
            if (wb_we_i = '1') then
              reg_frac_int_write <= wrdata_reg(31 downto 0);
              reg_frac_lw <= '1';
              reg_frac_lw_delay <= '1';
              reg_frac_lw_read_in_progress <= '0';
              reg_frac_rwsel <= '1';
            end if;
            if (wb_we_i = '0') then
              reg_frac_lw <= '1';
              reg_frac_lw_delay <= '1';
              reg_frac_lw_read_in_progress <= '1';
              reg_frac_rwsel <= '0';
            end if;
            ack_sreg(5) <= '1';
            ack_in_progress <= '1';
          when "100" => 
            if (wb_we_i = '1') then
              reg_mask_int_write <= wrdata_reg(31 downto 0);
              reg_mask_lw <= '1';
              reg_mask_lw_delay <= '1';
              reg_mask_lw_read_in_progress <= '0';
              reg_mask_rwsel <= '1';
            end if;
            if (wb_we_i = '0') then
              reg_mask_lw <= '1';
              reg_mask_lw_delay <= '1';
              reg_mask_lw_read_in_progress <= '1';
              reg_mask_rwsel <= '0';
            end if;
            ack_sreg(5) <= '1';
            ack_in_progress <= '1';
          when "101" => 
            if (wb_we_i = '1') then
              reg_phofsl_int_write <= wrdata_reg(31 downto 0);
              reg_phofsl_lw <= '1';
              reg_phofsl_lw_delay <= '1';
              reg_phofsl_lw_read_in_progress <= '0';
              reg_phofsl_rwsel <= '1';
            end if;
            if (wb_we_i = '0') then
              reg_phofsl_lw <= '1';
              reg_phofsl_lw_delay <= '1';
              reg_phofsl_lw_read_in_progress <= '1';
              reg_phofsl_rwsel <= '0';
            end if;
            ack_sreg(5) <= '1';
            ack_in_progress <= '1';
          when "110" => 
            if (wb_we_i = '1') then
              reg_phofsh_int_write <= wrdata_reg(31 downto 0);
              reg_phofsh_lw <= '1';
              reg_phofsh_lw_delay <= '1';
              reg_phofsh_lw_read_in_progress <= '0';
              reg_phofsh_rwsel <= '1';
            end if;
            if (wb_we_i = '0') then
              reg_phofsh_lw <= '1';
              reg_phofsh_lw_delay <= '1';
              reg_phofsh_lw_read_in_progress <= '1';
              reg_phofsh_rwsel <= '0';
            end if;
            ack_sreg(5) <= '1';
            ack_in_progress <= '1';
          when others =>
-- prevent the slave from hanging the bus on invalid address
            ack_in_progress <= '1';
            ack_sreg(0) <= '1';
          end case;
        end if;
      end if;
    end if;
  end process;
  
  
-- Drive the data output bus
  wb_dat_o <= rddata_reg;
-- Channel select bits
  reg_chsel_o <= reg_chsel_int;
-- Bits of currently selected banked register
-- asynchronous std_logic_vector register : Bits of currently selected banked register (type RW/WO, clk_ref_i <-> clk_sys_i)
  process (clk_ref_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      reg_per_lw_s0 <= '0';
      reg_per_lw_s1 <= '0';
      reg_per_lw_s2 <= '0';
      reg_per_o <= "00000000000000000000000000000000";
      reg_per_load_o <= '0';
      reg_per_int_read <= "00000000000000000000000000000000";
    elsif rising_edge(clk_ref_i) then
      reg_per_lw_s0 <= reg_per_lw;
      reg_per_lw_s1 <= reg_per_lw_s0;
      reg_per_lw_s2 <= reg_per_lw_s1;
      if ((reg_per_lw_s2 = '0') and (reg_per_lw_s1 = '1')) then
        if (reg_per_rwsel = '1') then
          reg_per_o <= reg_per_int_write;
          reg_per_load_o <= '1';
        else
          reg_per_load_o <= '0';
          reg_per_int_read <= reg_per_i;
        end if;
      else
        reg_per_load_o <= '0';
      end if;
    end if;
  end process;
  
  
-- Bits of currently selected banked register
-- asynchronous std_logic_vector register : Bits of currently selected banked register (type RW/WO, clk_ref_i <-> clk_sys_i)
  process (clk_ref_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      reg_perhi_lw_s0 <= '0';
      reg_perhi_lw_s1 <= '0';
      reg_perhi_lw_s2 <= '0';
      reg_perhi_o <= "00000000000000000000000000000000";
      reg_perhi_load_o <= '0';
      reg_perhi_int_read <= "00000000000000000000000000000000";
    elsif rising_edge(clk_ref_i) then
      reg_perhi_lw_s0 <= reg_perhi_lw;
      reg_perhi_lw_s1 <= reg_perhi_lw_s0;
      reg_perhi_lw_s2 <= reg_perhi_lw_s1;
      if ((reg_perhi_lw_s2 = '0') and (reg_perhi_lw_s1 = '1')) then
        if (reg_perhi_rwsel = '1') then
          reg_perhi_o <= reg_perhi_int_write;
          reg_perhi_load_o <= '1';
        else
          reg_perhi_load_o <= '0';
          reg_perhi_int_read <= reg_perhi_i;
        end if;
      else
        reg_perhi_load_o <= '0';
      end if;
    end if;
  end process;
  
  
-- Bits of currently selected banked register
-- asynchronous std_logic_vector register : Bits of currently selected banked register (type RW/WO, clk_ref_i <-> clk_sys_i)
  process (clk_ref_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      reg_frac_lw_s0 <= '0';
      reg_frac_lw_s1 <= '0';
      reg_frac_lw_s2 <= '0';
      reg_frac_o <= "00000000000000000000000000000000";
      reg_frac_load_o <= '0';
      reg_frac_int_read <= "00000000000000000000000000000000";
    elsif rising_edge(clk_ref_i) then
      reg_frac_lw_s0 <= reg_frac_lw;
      reg_frac_lw_s1 <= reg_frac_lw_s0;
      reg_frac_lw_s2 <= reg_frac_lw_s1;
      if ((reg_frac_lw_s2 = '0') and (reg_frac_lw_s1 = '1')) then
        if (reg_frac_rwsel = '1') then
          reg_frac_o <= reg_frac_int_write;
          reg_frac_load_o <= '1';
        else
          reg_frac_load_o <= '0';
          reg_frac_int_read <= reg_frac_i;
        end if;
      else
        reg_frac_load_o <= '0';
      end if;
    end if;
  end process;
  
  
-- Bits of currently selected banked register
-- asynchronous std_logic_vector register : Bits of currently selected banked register (type RW/WO, clk_ref_i <-> clk_sys_i)
  process (clk_ref_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      reg_mask_lw_s0 <= '0';
      reg_mask_lw_s1 <= '0';
      reg_mask_lw_s2 <= '0';
      reg_mask_o <= "00000000000000000000000000000000";
      reg_mask_load_o <= '0';
      reg_mask_int_read <= "00000000000000000000000000000000";
    elsif rising_edge(clk_ref_i) then
      reg_mask_lw_s0 <= reg_mask_lw;
      reg_mask_lw_s1 <= reg_mask_lw_s0;
      reg_mask_lw_s2 <= reg_mask_lw_s1;
      if ((reg_mask_lw_s2 = '0') and (reg_mask_lw_s1 = '1')) then
        if (reg_mask_rwsel = '1') then
          reg_mask_o <= reg_mask_int_write;
          reg_mask_load_o <= '1';
        else
          reg_mask_load_o <= '0';
          reg_mask_int_read <= reg_mask_i;
        end if;
      else
        reg_mask_load_o <= '0';
      end if;
    end if;
  end process;
  
  
-- Bits of currently selected banked register
-- asynchronous std_logic_vector register : Bits of currently selected banked register (type RW/WO, clk_ref_i <-> clk_sys_i)
  process (clk_ref_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      reg_phofsl_lw_s0 <= '0';
      reg_phofsl_lw_s1 <= '0';
      reg_phofsl_lw_s2 <= '0';
      reg_phofsl_o <= "00000000000000000000000000000000";
      reg_phofsl_load_o <= '0';
      reg_phofsl_int_read <= "00000000000000000000000000000000";
    elsif rising_edge(clk_ref_i) then
      reg_phofsl_lw_s0 <= reg_phofsl_lw;
      reg_phofsl_lw_s1 <= reg_phofsl_lw_s0;
      reg_phofsl_lw_s2 <= reg_phofsl_lw_s1;
      if ((reg_phofsl_lw_s2 = '0') and (reg_phofsl_lw_s1 = '1')) then
        if (reg_phofsl_rwsel = '1') then
          reg_phofsl_o <= reg_phofsl_int_write;
          reg_phofsl_load_o <= '1';
        else
          reg_phofsl_load_o <= '0';
          reg_phofsl_int_read <= reg_phofsl_i;
        end if;
      else
        reg_phofsl_load_o <= '0';
      end if;
    end if;
  end process;
  
  
-- Bits of currently selected banked register
-- asynchronous std_logic_vector register : Bits of currently selected banked register (type RW/WO, clk_ref_i <-> clk_sys_i)
  process (clk_ref_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      reg_phofsh_lw_s0 <= '0';
      reg_phofsh_lw_s1 <= '0';
      reg_phofsh_lw_s2 <= '0';
      reg_phofsh_o <= "00000000000000000000000000000000";
      reg_phofsh_load_o <= '0';
      reg_phofsh_int_read <= "00000000000000000000000000000000";
    elsif rising_edge(clk_ref_i) then
      reg_phofsh_lw_s0 <= reg_phofsh_lw;
      reg_phofsh_lw_s1 <= reg_phofsh_lw_s0;
      reg_phofsh_lw_s2 <= reg_phofsh_lw_s1;
      if ((reg_phofsh_lw_s2 = '0') and (reg_phofsh_lw_s1 = '1')) then
        if (reg_phofsh_rwsel = '1') then
          reg_phofsh_o <= reg_phofsh_int_write;
          reg_phofsh_load_o <= '1';
        else
          reg_phofsh_load_o <= '0';
          reg_phofsh_int_read <= reg_phofsh_i;
        end if;
      else
        reg_phofsh_load_o <= '0';
      end if;
    end if;
  end process;
  
  
  rwaddr_reg <= wb_adr_i;
  wb_stall_o <= (not ack_sreg(0)) and (wb_stb_i and wb_cyc_i);
-- ACK signal generation. Just pass the LSB of ACK counter.
  wb_ack_o <= ack_sreg(0);
end syn;
