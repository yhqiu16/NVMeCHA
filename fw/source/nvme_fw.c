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

#include <stdio.h>
#include "platform.h"
#include "nvme_admin_controller.h"


typedef enum _NVME_STATE_E
{
	NVME_STATE_DISABLED = 0,
	NVME_STATE_ENABLED,
	NVME_STATE_RUNNING,
	NVME_STATE_SHUTDOWN,
} NVME_STATE_E;


int main()
{
    init_platform();

    xil_printf("======NVMe Test Start========\n\r");
    enable_xdma_channels();
    init_nvme_controller(1);
    NVME_STATE_E state = NVME_STATE_DISABLED;
    while(xdma_msi_enable_get() == 0){
    	usleep(100);
    }
	while(1){
		switch(state)
		{
			case NVME_STATE_DISABLED:{
				if(get_reg_cc_en() == 1){
					state = NVME_STATE_ENABLED;
					xil_printf("NVMe Reg CC_EN is set\n\r");
				}
				break;
			}
			case(NVME_STATE_ENABLED): {
				state = NVME_STATE_RUNNING;
				init_nvme_controller(0);
				set_csts_rdy(1);
//				xdma_msix_vector_print();
				xil_printf("PS Set CSTS RDY \n\r");
				break;
			}
			case(NVME_STATE_RUNNING): {
				if(get_reg_cc_en() == 0){
					state = NVME_STATE_DISABLED;
					init_nvme_controller(1);
					set_csts_rdy(0);
					xil_printf("Controller Reset \n\r");
				} else if(get_reg_cc_shn()){
					state = NVME_STATE_SHUTDOWN;
//					init_nvme_controller(1);
					set_csts_shst(2);
					xil_printf("Controller Shutdown \n\r");
				} else {
					nvme_main_process();
				}
				break;
			}
			case(NVME_STATE_SHUTDOWN):{
				if(get_reg_cc_en() == 0){
					state = NVME_STATE_DISABLED;
					set_csts_shst(0);
					set_csts_rdy(0);
					xil_printf("Controller Restart \n\r");
				}
				break;
			}
			default: state = NVME_STATE_DISABLED;
		}
	}

//	xil_printf("======NVMe Test End========\n\r");
    cleanup_platform();
    return 0;
}
