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
 * NVMe IO SQ and CQ Database
 *   cache SQ & CQ attributes, eg, base address, qid, qsize
 *   they are cached as arrays in physical contiguous space
 */

#ifndef __NVME_IO_QUE_DB_H__
#define __NVME_IO_QUE_DB_H__

#include "nvme_structs.h"
#include "string.h"

#define SQ_ATTRIBUTE_SIZE	(16)
#define CQ_ATTRIBUTE_SIZE	(16)

// IO SQ Attributes
typedef struct _sq_attribute_t{
	u16 qid;             // queue ID
	u16 qsize;           // queue size
	u16 cqid;            // CQ ID
	u16 qprio		: 2; // queue priority
	u16 reserved0	: 14;
	u64 qbase_addr;      // queue base address
} sq_attribute_t;

// IO CQ Attributes
typedef struct _cq_attribute_t{
	u16 qid;             // queue ID
	u16 qsize;           // queue size
	u16 iv;              // interrupt vector
	u16 ien			: 1; // interrupt enable
	u16 reserved0	: 15;
	u64 qbase_addr;      // queue base address
} cq_attribute_t;

// paired SQ & CQ need to have the same index
// only support one CQ to one SQ
sq_attribute_t g_sqs_attribute[NVME_IO_SQ_NUM];
cq_attribute_t g_cqs_attribute[NVME_IO_CQ_NUM];

//// hash table item
//typedef struct _hash_item_t{
//	u16 qid;       // queue ID, qid = 0 : item is invalid
//	u32 qa_ptr;  // sq_attribute/cq_attribute pointer
//} hash_item_t;
//
//
//hash_item_t g_hash_item_sq[NVME_IO_SQ_NUM];
//hash_item_t g_hash_item_cq[NVME_IO_CQ_NUM];
//
//// initialize hash items for sq/cq
//void init_hash_items_sq();
//void init_hash_items_cq();

// initialize sq_attribute/cq_attribute
void init_sqs_attribute();
void init_cqs_attribute();


// set/get/del sq_attribute/cq_attribute pointer in g_sqs_attribute/g_cqs_attribute
// *index is the array index
// return TRUE/FALSE
u32 set_sq_attribute(u16 cq_id, sq_attribute_t* sqa, u32 *index); // sq index needs to be the same with paired cq
u32 set_cq_attribute(u16 qid, cq_attribute_t* cqa, u32 *index);
u32 get_sq_attribute(u16 qid, sq_attribute_t* sqa, u32 *index);
u32 get_cq_attribute(u16 qid, cq_attribute_t* cqa, u32 *index);
u32 del_sq_attribute(u16 qid, u32 *index);
u32 del_cq_attribute(u16 qid, u32 *index);

// check if sq/cq exist according to qid or index
// return TRUE/FALSE
u32 sq_exist(u16 qid);
u32 cq_exist(u16 qid);
u32 sq_exist_at_index(u32 index);
u32 cq_exist_at_index(u32 index);

// find paired SQ according to cq_id
//u32 find_paired_sq(u16 cq_id, u16* sq_id);


#endif
