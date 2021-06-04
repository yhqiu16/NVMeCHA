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

#include "mem_rw.h"

// read data from memory to buffer
void mem_read(const u32 mem_addr, void* buf, size_t size)
{
	Xil_DCacheInvalidateRange(mem_addr, size);
	memcpy(buf, (void *)mem_addr, size);
}

// write data from buffer to memory
void mem_write(u32 mem_addr, const void* buf, size_t size)
{
	memcpy((void *)mem_addr, buf, size);
	Xil_DCacheFlushRange(mem_addr, size);
}
