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

/**
 * read or write registers in PL through AXI4 interfaces (DP)
 */


#ifndef __REG_RW__
#define __REG_RW__


#include "xil_io.h"
#include "xil_types.h"
#include "hw_params.h"


// enable/disable XDMA H2C/C2H channel
void xdma_h2c_chan_enable(u32 chan_num);
void xdma_c2h_chan_enable(u32 chan_num);
void xdma_h2c_chan_disable(u32 chan_num);
void xdma_c2h_chan_disable(u32 chan_num);

// set XDMA User interrupt Enable Mask Register, RW
void xdma_usr_irq_enable(u32 value);
// set XDMA Channel interrupt Enable Mask Register, RW
void xdma_channel_irq_enable(u32 value);
// Initialize XDMA IRQ User vector number
void xdma_usr_irq_vector_init();
// set XDMA IRQ User vector number, read-revise-write
void xdma_usr_irq_vector_set(u16 irq_num, u16 vec_num);
// print XDMA MSI-X IRQ Vector Table and Pending bits
void xdma_msix_vector_print();
// get MSI/MSI-X Enabled, [0] MSI Enable, [1] MSI-X enable
u32 xdma_msi_enable_get();


// Read/Write PL-side user registers
u32 get_asq_dsc_ctl();
u32 get_asq_dsc_len();
u64 get_asq_dsc_addr();
u32 get_acq_dsc_ctl();
u32 get_acq_dsc_len();
u64 get_acq_dsc_addr();

u32 get_reg_cc_en();
u32 get_csts_rdy();
u32 get_reg_cc_shn();
u32 get_csts_shst();

u32 get_asq_buf_wptr();
u32 get_acq_buf_rptr();
u32 get_h2c_dma_status();
u32 get_c2h_dma_status();

u32 get_sq_reset();
u32 get_cq_reset();
u32 get_iocq_irq_enable();

u64 get_sq_base_addr(u32 q_num);
u16 get_sq_size(u32 q_num);
u16 get_sq_id(u32 q_num);
u64 get_cq_base_addr(u32 q_num);
u16 get_cq_size(u32 q_num);
u16 get_cq_id(u32 q_num);

void set_asq_dsc_ctl(u32 value);
void set_asq_dsc_len(u32 value);
void set_asq_dsc_addr(u64 value);
void set_acq_dsc_ctl(u32 value);
void set_acq_dsc_len(u32 value);
void set_acq_dsc_addr(u64 value);

void set_csts_rdy(u32 value);
void set_csts_shst(u32 value);

void set_sq_reset(u32 value);
void set_cq_reset(u32 value);
void set_iocq_irq_enable(u32 value);

void set_sq_base_addr(u32 q_num, u64 value);
void set_sq_size_id(u32 q_num, u16 size, u16 id);
//void set_sq_size(u32 q_num, u16 value);
//void set_sq_id(u32 q_num, u16 value);
void set_cq_base_addr(u32 q_num, u64 value);
void set_cq_size_id(u32 q_num, u16 size, u16 id);
//void set_cq_size(u32 q_num, u16 value);
//void set_cq_id(u32 q_num, u16 value);



#endif
