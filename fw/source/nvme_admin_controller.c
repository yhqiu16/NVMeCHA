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

#include "nvme_admin_controller.h"


void enable_xdma_channels()
{
    xdma_h2c_chan_enable(0);
    xdma_h2c_chan_enable(1);
    xdma_h2c_chan_enable(2);
    xdma_h2c_chan_enable(3);
    xdma_c2h_chan_enable(0);
    xdma_c2h_chan_enable(1);
    xdma_c2h_chan_enable(2);
    xdma_c2h_chan_enable(3);
}

void init_nvme_controller(int flag)
{
	if(flag == 0)
		xdma_usr_irq_enable(0xffff);
	else
		xdma_usr_irq_enable(0x0);
	xdma_channel_irq_enable(0x0);
	xdma_usr_irq_vector_init();
    init_sqs_attribute();
    init_cqs_attribute();
    nvme_transmitter_init();
    set_iocq_irq_enable(0x0);
    for(u32 i = 1; i <= NVME_IO_SQ_NUM; i++){
    	set_sq_base_addr(i, 0);
    	set_sq_size_id(i, 0, 0);
    }
    for(u32 i = 1; i <= NVME_IO_CQ_NUM; i++){
    	set_cq_base_addr(i, 0);
    	set_cq_size_id(i, 0, 0);
    }
}


//void disable_nvme_controller()
//{
//	xdma_usr_irq_enable(0x0);
//	xdma_channel_irq_enable(0x0);
//    init_sqs_attribute();
//    init_cqs_attribute();
//    nvme_transmitter_init();
//    set_iocq_irq_enable(0x0);
//    for(u32 i = 1; i <= NVME_IO_SQ_NUM; i++){
//    	set_sq_base_addr(i, 0);
//    	set_sq_size_id(i, 0, 0);
//    }
//    for(u32 i = 1; i <= NVME_IO_CQ_NUM; i++){
//    	set_cq_base_addr(i, 0);
//    	set_cq_size_id(i, 0, 0);
//    }
//}


// return 1 : need submit CQ entry, 0 : do not need submit CQ entry
int process_admin_cmd(nvme_sq_entry_t* sq_entry, nvme_cq_entry_t* cq_entry)
{
	memset(cq_entry, 0x0, sizeof(nvme_cq_entry_t));

	int need_cqe = 1;
	switch (sq_entry->opc)
	{
		case NVME_ADMIN_OPCODE_DELETE_IO_SQ:
		{
			delete_io_sq(sq_entry, cq_entry);

			break;
		}
		case NVME_ADMIN_OPCODE_CREATE_IO_SQ:
		{
			create_io_sq(sq_entry, cq_entry);

			break;
		}
		case NVME_ADMIN_OPCODE_GET_LOG_PAGE:
		{
			get_log_page(sq_entry, cq_entry);

			break;
		}
		case NVME_ADMIN_OPCODE_DELETE_IO_CQ:
		{
			delete_io_cq(sq_entry, cq_entry);

			break;
		}
		case NVME_ADMIN_OPCODE_CREATE_IO_CQ:
		{
			create_io_cq(sq_entry, cq_entry);

			break;
		}
		case NVME_ADMIN_OPCODE_IDENTIFY:
		{
			identify(sq_entry, cq_entry);

			break;
		}
		case NVME_ADMIN_OPCODE_SET_FEATURE:
		{
			set_feature(sq_entry, cq_entry);

			break;
		}
		case NVME_ADMIN_OPCODE_GET_FEATURE:
		{
			get_feature(sq_entry, cq_entry);

			break;
		}
		case NVME_ADMIN_OPCODE_ASYNCHRONOUS_EVENT:
		{
			async_event_req(sq_entry, cq_entry);
			need_cqe = 0;
			break;
		}
		case NVME_ADMIN_OPCODE_ABORT:
		{
			cmd_abort(sq_entry, cq_entry);

			break;
		}
		default:
		{
			xil_printf("Unsupported Admin Command, OPC:%x\n\r", sq_entry->opc);
			cq_entry->cid = sq_entry->cid;
			cq_entry->sct = 0;
			cq_entry->sc = 2;  // invalid field
		}
	}
	return need_cqe;
}



void nvme_main_process()
{
	nvme_sq_entry_t sq_entry;
	nvme_cq_entry_t cq_entry;
	if(nvme_read_sq_entry(&sq_entry) == FALSE){
		usleep(100);
		return;
	}
	int need_cqe = process_admin_cmd(&sq_entry, &cq_entry);
	if(need_cqe){
		while(nvme_write_cq_entry(&cq_entry) == FALSE){
			usleep(100);
		}
//		xdma_msix_vector_print();
	}
}
