## ==== Clock (100 MHz) ====
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports {clk}]
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0 5} [get_ports {clk}]

## Reset button (BTNC, active-low)
set_property -dict { PACKAGE_PIN C12 IOSTANDARD LVCMOS33 } [get_ports { rst_n }];


## ==== Switch (10원/5원 선택: SW0) ====
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports {sw_coin10}] ;# SW0

## ==== Buttons ====
# BTNC → 동전 입력 버튼 (sense)
set_property -dict { PACKAGE_PIN N17 IOSTANDARD LVCMOS33 } [get_ports {btn_sense}]
# BTNL → 상품1
set_property -dict { PACKAGE_PIN P17 IOSTANDARD LVCMOS33 } [get_ports {btn_item1}]
# BTNR → 상품2
set_property -dict { PACKAGE_PIN M17 IOSTANDARD LVCMOS33 } [get_ports {btn_item2}]
# BTNU → 구매확정
set_property -dict { PACKAGE_PIN M18 IOSTANDARD LVCMOS33 } [get_ports {btn_buy}]
# BTND → 구매취소
set_property -dict { PACKAGE_PIN P18 IOSTANDARD LVCMOS33 } [get_ports {btn_cancel}]

## ==== LEDs (상품 LED 2개만 사용) ====
set_property -dict { PACKAGE_PIN H17 IOSTANDARD LVCMOS33 } [get_ports {led[0]}] ;# LD0
set_property -dict { PACKAGE_PIN K15 IOSTANDARD LVCMOS33 } [get_ports {led[1]}] ;# LD1

## ==== 7-Segment (공통 애노드 8자리) ====
# Segments (A..G, DP)  →  sseg[0]..sseg[6], DP
set_property -dict { PACKAGE_PIN T10 IOSTANDARD LVCMOS33 } [get_ports {sseg[0]}] ;# CA
set_property -dict { PACKAGE_PIN R10 IOSTANDARD LVCMOS33 } [get_ports {sseg[1]}] ;# CB
set_property -dict { PACKAGE_PIN K16 IOSTANDARD LVCMOS33 } [get_ports {sseg[2]}] ;# CC
set_property -dict { PACKAGE_PIN K13 IOSTANDARD LVCMOS33 } [get_ports {sseg[3]}] ;# CD
set_property -dict { PACKAGE_PIN P15 IOSTANDARD LVCMOS33 } [get_ports {sseg[4]}] ;# CE
set_property -dict { PACKAGE_PIN T11 IOSTANDARD LVCMOS33 } [get_ports {sseg[5]}] ;# CF
set_property -dict { PACKAGE_PIN L18 IOSTANDARD LVCMOS33 } [get_ports {sseg[6]}] ;# CG
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports {DP}]       ;# DP

# Anodes (AN0..AN7) → AN[0]..AN[7]  (액티브-로우: 0=해당 자리 켜짐)
set_property -dict { PACKAGE_PIN J17 IOSTANDARD LVCMOS33 } [get_ports {AN[0]}]
set_property -dict { PACKAGE_PIN J18 IOSTANDARD LVCMOS33 } [get_ports {AN[1]}]
set_property -dict { PACKAGE_PIN T9  IOSTANDARD LVCMOS33 } [get_ports {AN[2]}]
set_property -dict { PACKAGE_PIN J14 IOSTANDARD LVCMOS33 } [get_ports {AN[3]}]
set_property -dict { PACKAGE_PIN P14 IOSTANDARD LVCMOS33 } [get_ports {AN[4]}]
set_property -dict { PACKAGE_PIN T14 IOSTANDARD LVCMOS33 } [get_ports {AN[5]}]
set_property -dict { PACKAGE_PIN K2  IOSTANDARD LVCMOS33 } [get_ports {AN[6]}]
set_property -dict { PACKAGE_PIN U13 IOSTANDARD LVCMOS33 } [get_ports {AN[7]}]
