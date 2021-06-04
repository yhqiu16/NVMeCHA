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
 * NVMe Admin Command Set
 */

#ifndef __NVME_ADMIN_CMDS_H__
#define __NVME_ADMIN_CMDS_H__

#include "nvme_io_que_db.h"
#include "nvme_regs.h"
#include "nvme_transmitter.h"
#include "xil_printf.h"

u32 g_buf[1024];

#define BRAM_BUF_BASEADDR		(g_buf)

void create_io_sq(nvme_sq_entry_t* sq_entry, nvme_cq_entry_t* cq_entry);
void create_io_cq(nvme_sq_entry_t* sq_entry, nvme_cq_entry_t* cq_entry);
void delete_io_sq(nvme_sq_entry_t* sq_entry, nvme_cq_entry_t* cq_entry);
void delete_io_cq(nvme_sq_entry_t* sq_entry, nvme_cq_entry_t* cq_entry);
void get_log_page(nvme_sq_entry_t* sq_entry, nvme_cq_entry_t* cq_entry);
void identify(nvme_sq_entry_t* sq_entry, nvme_cq_entry_t* cq_entry);
void set_feature(nvme_sq_entry_t* sq_entry, nvme_cq_entry_t* cq_entry);
void get_feature(nvme_sq_entry_t* sq_entry, nvme_cq_entry_t* cq_entry);
void async_event_req(nvme_sq_entry_t* sq_entry, nvme_cq_entry_t* cq_entry);
void cmd_abort(nvme_sq_entry_t* sq_entry, nvme_cq_entry_t* cq_entry);




#endif 	//__NVME_ADMIN_CMDS_H__
