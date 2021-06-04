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
 * NVMe Admin Controller
 */

#ifndef __NVME_ADMIN_CONTROLLER_H__
#define __NVME_ADMIN_CONTROLLER_H__


#include "nvme_admin_cmds.h"
#include "sleep.h"

void enable_xdma_channels();

// flag = 0: start, 1 : shutdown
void init_nvme_controller(int flag);
//void disable_nvme_controller();

// process admin command according to sq_entry
// return 0 : need submit CQ entry, 1 : do not need submit CQ entry
int process_admin_cmd(nvme_sq_entry_t* sq_entry, nvme_cq_entry_t* cq_entry);

// NVMe main process: including read sq_entry, process command, write cq_entry
void nvme_main_process();



#endif
