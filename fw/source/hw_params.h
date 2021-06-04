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
 * Hardware Parameters, including:
 *   Register addresses, BRAM buffer addresses...
 */
#ifndef __HW_PARAMS__
#define __HW_PARAMS__

//#include "xparameters.h"


// XDMA internal registers base address, XPAR_M0_AXI_BASEADDR
#define XDMA_REG_BASEADDR  				(0x44A20000)
// PL-side user registers base address, XPAR_AXI_BRAM_CTRL_0_S_AXI_BASEADDR
#define USER_REG_BASEADDR  				(0x44A40000)
// PL-side SQ-entry buffer base address, XPAR_AXI_BRAM_CTRL_1_S_AXI_BASEADDR
#define PL_SQ_ENTRY_BUF_BASEADDR		(0x44A50000)
// PL-side SQ-entry buffer size(number of SQ entries)
#define PL_SQ_ENTRY_NUM 				(8)
// PL-side CQ-entry buffer base address, XPAR_AXI_BRAM_CTRL_1_S_AXI_BASEADDR
#define PL_CQ_ENTRY_BUF_BASEADDR		(0x44A50000)
// PL-side CQ-entry buffer size(number of CQ entries)
#define PL_CQ_ENTRY_NUM					(8)
// PL-side SQ-data buffer base address, XPAR_AXI_BRAM_CTRL_2_S_AXI_BASEADDR
#define PL_SQ_DATA_BUF_BASEADDR			(0x44A51000)
// PL-side SQ-data buffer size(byte)
#define PL_SQ_DATA_BUF_SIZE				(4096)
// PL-side CQ-data buffer base address, XPAR_AXI_BRAM_CTRL_2_S_AXI_BASEADDR
#define PL_CQ_DATA_BUF_BASEADDR			(0x44A51000)
// PL-side CQ-data buffer size(byte)
#define PL_CQ_DATA_BUF_SIZE				(4096)

// XDMA internal registers offset address
#define XDMA_H2C_CHAN_0_CTRL_ADDR    (0x0004)
#define XDMA_C2H_CHAN_0_CTRL_ADDR    (0x1004)
#define XDMA_USR_IRQ_EN_ADDR         (0x2004)
#define XDMA_CHANNEL_IRQ_EN_ADDR     (0x2010)
#define XDMA_USR_IRQ_VECTOR_0_ADDR	 (0x2080)
#define XDMA_MSI_ENABLE_ADDR         (0x3014)
#define XDMA_MSIX_VECTOR_TABLE_ADDR  (0x8000)
#define XDMA_MSIX_PBA_ADDR           (0x8FE0)

#define XDMA_CHAN_ENABLE_VALUE       (0x0fffe7f)

// PL-side user registers offset address
#define ADDR_ASQ_DSC_CTL      		 (0x0000)
#define ADDR_ASQ_DSC_LEN      		 (0x0004)
#define ADDR_ASQ_DSC_ADDRL    		 (0x0008)
#define ADDR_ASQ_DSC_ADDRH    		 (0x000C)
#define ADDR_ACQ_DSC_CTL      		 (0x0010)
#define ADDR_ACQ_DSC_LEN      		 (0x0014)
#define ADDR_ACQ_DSC_ADDRL    		 (0x0018)
#define ADDR_ACQ_DSC_ADDRH    		 (0x001C)
#define ADDR_REG_CC_EN        		 (0x0020)
#define ADDR_CSTS_RDY         		 (0x0024)
#define ADDR_REG_CC_SHN        		 (0x0028)
#define ADDR_CSTS_SHST         		 (0x002C)
#define ADDR_ASQ_BUF_WPTR	  		 (0x0040)
#define ADDR_ACQ_BUF_RPTR     		 (0x0044)
#define ADDR_H2C_DMA_STATUS   		 (0x0048)
#define ADDR_C2H_DMA_STATUS   		 (0x004C)
#define ADDR_SQ_RESET         		 (0x0070)
#define ADDR_CQ_RESET         		 (0x0074)
#define ADDR_IOCQ_IRQ_ENABLE  		 (0x0078)
#define ADDR_IO_QUEUE         		 (0x0080)


#endif
