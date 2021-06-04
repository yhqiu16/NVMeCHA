/**
* NVMeCHA: NVMe Controller featuring Hardware Acceleration
* Copyright (C) 2021 State Key Laboratory of ASIC and System, Fudan University
* Contributed by Yunhui Qiu
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "reg_rw.h"

// enable/disable XDMA H2C/C2H channel
void xdma_h2c_chan_enable(u32 chan_num)
{
	u32 addr = XDMA_REG_BASEADDR + XDMA_H2C_CHAN_0_CTRL_ADDR + chan_num * 0x0100;
	Xil_Out32(addr, XDMA_CHAN_ENABLE_VALUE);
}


void xdma_c2h_chan_enable(u32 chan_num)
{
	u32 addr = XDMA_REG_BASEADDR + XDMA_C2H_CHAN_0_CTRL_ADDR + chan_num * 0x0100;
	Xil_Out32(addr, XDMA_CHAN_ENABLE_VALUE);
}


void xdma_h2c_chan_disable(u32 chan_num)
{
	u32 addr = XDMA_REG_BASEADDR + XDMA_H2C_CHAN_0_CTRL_ADDR + chan_num * 0x0100;
	Xil_Out32(addr, 0);
}


void xdma_c2h_chan_disable(u32 chan_num)
{
	u32 addr = XDMA_REG_BASEADDR + XDMA_C2H_CHAN_0_CTRL_ADDR + chan_num * 0x0100;
	Xil_Out32(addr, 0);
}


// set XDMA User interrupt Enable Mask Register, RW
void xdma_usr_irq_enable(u32 value)
{
	Xil_Out32(XDMA_REG_BASEADDR + XDMA_USR_IRQ_EN_ADDR, value);
}


// set XDMA Channel interrupt Enable Mask Register, RW
void xdma_channel_irq_enable(u32 value)
{
	Xil_Out32(XDMA_REG_BASEADDR + XDMA_CHANNEL_IRQ_EN_ADDR, value);
}


// Initialize XDMA IRQ User vector number
void xdma_usr_irq_vector_init()
{
//	for(u32 i = 0; i < 4; i++){
//		Xil_Out32(XDMA_REG_BASEADDR + XDMA_USR_IRQ_VECTOR_0_ADDR + 4*i, 1);
//	}
	Xil_Out32(XDMA_REG_BASEADDR + XDMA_USR_IRQ_VECTOR_0_ADDR + 0x0, 0x03020100);
	Xil_Out32(XDMA_REG_BASEADDR + XDMA_USR_IRQ_VECTOR_0_ADDR + 0x4, 0x07060504);
	Xil_Out32(XDMA_REG_BASEADDR + XDMA_USR_IRQ_VECTOR_0_ADDR + 0x8, 0x0b0a0908);
	Xil_Out32(XDMA_REG_BASEADDR + XDMA_USR_IRQ_VECTOR_0_ADDR + 0xc, 0x0f0e0d0c);
}


// set XDMA IRQ User vector number, read-revise-write
void xdma_usr_irq_vector_set(u16 irq_num, u16 vec_num)
{
	u32 addr = XDMA_REG_BASEADDR + XDMA_USR_IRQ_VECTOR_0_ADDR + (irq_num/4)*4;
	u32 data = Xil_In32(addr);
	u32 index = irq_num%4;
	u32 wr_data;
	switch(index){
		case 0: wr_data = (data & 0xFFFFFF00) | (u32)vec_num; break;
		case 1: wr_data = (data & 0xFFFF00FF) | ((u32)vec_num << 8); break;
		case 2: wr_data = (data & 0xFF00FFFF) | ((u32)vec_num << 16); break;
		case 3: wr_data = (data & 0x00FFFFFF) | ((u32)vec_num << 24); break;
	}
//	xil_printf("IRQ Vector addr: 0x%x, rd_data: 0x%x, wr_data: 0x%x\n\r", addr, data, wr_data);
	Xil_Out32(addr, wr_data);
}



// print XDMA MSI-X IRQ Vector Table and Pending bits
void xdma_msix_vector_print()
{
	int N = 16;
	for (int i = 0; i < 4*N; i++){
		u32 value = Xil_In32(XDMA_REG_BASEADDR + XDMA_MSIX_VECTOR_TABLE_ADDR + 4*i);
		switch(i%4){
				case 0: xil_printf("MSIX Vector Lower Address: 0x%x, ", value); break;
				case 1: xil_printf("Upper Address: 0x%x, ", value); break;
				case 2: xil_printf("Data: 0x%x, ", value); break;
				case 3: xil_printf("Control: 0x%x\n\r", value); break;
			}
	}
	u32 value = Xil_In32(XDMA_REG_BASEADDR + XDMA_MSIX_PBA_ADDR);
	xil_printf("MSIX PBA: 0x%x\n\r", value);
}


// get MSI/MSI-X Enabled, [0] MSI Enable, [1] MSI-X enable
u32 xdma_msi_enable_get()
{
	return Xil_In32(XDMA_REG_BASEADDR + XDMA_MSI_ENABLE_ADDR);
}


// Read/Write PL-side user registers
u32 get_asq_dsc_ctl()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_ASQ_DSC_CTL);
}

u32 get_asq_dsc_len()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_ASQ_DSC_LEN);
}

u64 get_asq_dsc_addr()
{
	u32 value_l32 = Xil_In32(USER_REG_BASEADDR + ADDR_ASQ_DSC_ADDRL);
	u32 value_h32 = Xil_In32(USER_REG_BASEADDR + ADDR_ASQ_DSC_ADDRH);
	return ((u64)value_h32 << 32) | value_l32;
}

u32 get_acq_dsc_ctl()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_ACQ_DSC_CTL);
}

u32 get_acq_dsc_len()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_ACQ_DSC_LEN);
}

u64 get_acq_dsc_addr()
{
	u32 value_l32 = Xil_In32(USER_REG_BASEADDR + ADDR_ACQ_DSC_ADDRL);
	u32 value_h32 = Xil_In32(USER_REG_BASEADDR + ADDR_ACQ_DSC_ADDRH);
	return ((u64)value_h32 << 32) | value_l32;
}

u32 get_reg_cc_en()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_REG_CC_EN);
}

u32 get_csts_rdy()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_CSTS_RDY);
}


u32 get_reg_cc_shn()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_REG_CC_SHN);
}


u32 get_csts_shst()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_CSTS_SHST);
}


u32 get_asq_buf_wptr()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_ASQ_BUF_WPTR);
}


u32 get_acq_buf_rptr()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_ACQ_BUF_RPTR);
}


u32 get_h2c_dma_status()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_H2C_DMA_STATUS);
}

u32 get_c2h_dma_status()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_C2H_DMA_STATUS);
}


u32 get_sq_reset()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_SQ_RESET);
}

u32 get_cq_reset()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_CQ_RESET);
}

u32 get_iocq_irq_enable()
{
	return Xil_In32(USER_REG_BASEADDR + ADDR_IOCQ_IRQ_ENABLE);
}


u64 get_sq_base_addr(u32 q_num)
{
	u32 value_l32 = Xil_In32(USER_REG_BASEADDR + ADDR_IO_QUEUE + q_num * 24);
	u32 value_h32 = Xil_In32(USER_REG_BASEADDR + ADDR_IO_QUEUE + q_num * 24 + 4);
	return ((u64)value_h32 << 32) | value_l32;
}

u16 get_sq_size(u32 q_num)
{
	u32 value = Xil_In32(USER_REG_BASEADDR + ADDR_IO_QUEUE + q_num * 24 + 8);
	return (u16)(value >> 16);
}

u16 get_sq_id(u32 q_num)
{
	u32 value = Xil_In32(USER_REG_BASEADDR + ADDR_IO_QUEUE + q_num * 24 + 8);
	return (u16)value;
}

u64 get_cq_base_addr(u32 q_num)
{
	u32 value_l32 = Xil_In32(USER_REG_BASEADDR + ADDR_IO_QUEUE + q_num * 24 + 12);
	u32 value_h32 = Xil_In32(USER_REG_BASEADDR + ADDR_IO_QUEUE + q_num * 24 + 16);
	return ((u64)value_h32 << 32) | value_l32;
}

u16 get_cq_size(u32 q_num)
{
	u32 value = Xil_In32(USER_REG_BASEADDR + ADDR_IO_QUEUE + q_num * 24 + 20);
	return (u16)(value >> 16);
}

u16 get_cq_id(u32 q_num)
{
	u32 value = Xil_In32(USER_REG_BASEADDR + ADDR_IO_QUEUE + q_num * 24 + 20);
	return (u16)value;
}



void set_asq_dsc_ctl(u32 value)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_ASQ_DSC_CTL), value);
}

void set_asq_dsc_len(u32 value)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_ASQ_DSC_LEN), value);
}

void set_asq_dsc_addr(u64 value)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_ASQ_DSC_ADDRL), (u32)value);
	Xil_Out32((USER_REG_BASEADDR + ADDR_ASQ_DSC_ADDRH), (u32)(value >> 32));
}

void set_acq_dsc_ctl(u32 value)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_ACQ_DSC_CTL), value);
}

void set_acq_dsc_len(u32 value)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_ACQ_DSC_LEN), value);
}

void set_acq_dsc_addr(u64 value)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_ACQ_DSC_ADDRL), (u32)value);
	Xil_Out32((USER_REG_BASEADDR + ADDR_ACQ_DSC_ADDRH), (u32)(value >> 32));
}


void set_csts_rdy(u32 value)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_CSTS_RDY), value);
}

void set_csts_shst(u32 value)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_CSTS_SHST), value);
}


void set_sq_reset(u32 value)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_SQ_RESET), value);
}

void set_cq_reset(u32 value)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_CQ_RESET), value);
}

void set_iocq_irq_enable(u32 value)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_IOCQ_IRQ_ENABLE), value);
}


void set_sq_base_addr(u32 q_num, u64 value)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_IO_QUEUE + q_num * 24), (u32)value);
	Xil_Out32((USER_REG_BASEADDR + ADDR_IO_QUEUE + q_num * 24 + 4), (u32)(value >> 32));
}

void set_sq_size_id(u32 q_num, u16 size, u16 id)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_IO_QUEUE + q_num * 24 + 8), ((u32)size << 16) | id);
}

void set_cq_base_addr(u32 q_num, u64 value)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_IO_QUEUE + q_num * 24 + 12), (u32)value);
	Xil_Out32((USER_REG_BASEADDR + ADDR_IO_QUEUE + q_num * 24 + 16), (u32)(value >> 32));
}

void set_cq_size_id(u32 q_num, u16 size, u16 id)
{
	Xil_Out32((USER_REG_BASEADDR + ADDR_IO_QUEUE + q_num * 24 + 20), ((u32)size << 16) | id);
}
