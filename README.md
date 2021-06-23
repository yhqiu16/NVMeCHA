# NVMeCHA
NVMe Controller featuring Hardware Acceleration

# Introduction
NVMeCHA is an ultralow-latency and high-throughput NVMe controller with a highly parallel, pipelined, and scalable architecture that accommodates one admin controller and multiple fully hardware-automated I/O controllers.
The admin controller features the software-hardware co-design, where the complex processing of the NVMe admin commands is managed by software whereas the data transmission over PCIe is handled by hardware. This hybrid architecture combines software flexibility and hardware efficiency to reduce CPU resources and improve performance. 
The I/O controller is designed with a highly parallel and pipelined hardware architecture that allows many NVMe I/O commands to be processed in parallel without any software intervention. Each I/O controller is corresponding to one NVMe I/O queue pair.

# Performance
We implement the NVMe controller in a Xilinx KCU105 FPGA board, which is connected to a computer via a PCIe gen3 x8 interface. Evaluated by the SPDK-Perf benchmark tool, the maximum bandwidth of our NVMe controller can achieve 7.0GB/s for both reads and writes, accounting for 89% of the theoretical PCIe bandwidth. The maximum 4KB-sized read/write throughput can attain 1.7 million I/O operations per second (MIOPS). The average 4KB-sized read/write latency is merely 2.4μs/3.2μs. 

# Project Setup
1. Target FPGA device: Xilinx KCU105 Board
2. Development tools: Vivado 2019.2, Vitis 2019.2

# Publications
Y. Qiu, W. Yin and L. Wang, "A High-Performance and Scalable NVMe Controller Featuring Hardware Acceleration," in IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems, doi: 10.1109/TCAD.2021.3088784.

