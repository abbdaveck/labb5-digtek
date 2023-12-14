@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.1\\bin
call %xv_path%/xelab  -wto 52ec65184674441c8b031a2c11785ea6 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot cpu_tb_behav xil_defaultlib.cpu_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
