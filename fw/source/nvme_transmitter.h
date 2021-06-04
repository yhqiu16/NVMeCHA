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
 * NVMe Transmitter
 * 	Read SQ entries, Write CQ entries, Write data of identify, get log ...
 */


#ifndef __NVME_TRANSMITTER_H__
#define __NVME_TRANSMITTER_H__

#include "reg_rw.h"
#include "nvme_structs.h"
#include "mem_rw.h"

void nvme_transmitter_init();

/* Write XDMA Descriptors to PL registers */
// Host to Card(PS) direction
void write_h2c_dsc(u64 base_addr, u32 len);
// Card(PS) to Host direction
void write_c2h_dsc(u64 base_addr, u32 len);


// Read SQ entry from PL-side buffer
// return TRUE/FALSE
u32 nvme_read_sq_entry(nvme_sq_entry_t* sq_entry);

// Write CQ entry to PL-side buffer
// return TRUE/FALSE
u32 nvme_write_cq_entry(nvme_cq_entry_t* cq_entry);

// Read data that host provides from SQ data buffer
// return TRUE/FALSE
u32 nvme_read_sq_data(u64 dsc_base_addr, u32* buf, u32 size);

// Write data that host requests to CQ data buffer
// return TRUE/FALSE
u32 nvme_write_cq_data(u64 dsc_base_addr, u32* buf, u32 size);

//// Batch mode, batch_num is the entry number
//u32 nvme_read_sq_entry_batch(u64 dsc_base_addr, nvme_sq_entry_t** sq_entry, u32 batch_num);
//u32 nvme_write_cq_entry_batch(u64 dsc_base_addr, nvme_cq_entry_t** cq_entry, u32 batch_num);

#endif
