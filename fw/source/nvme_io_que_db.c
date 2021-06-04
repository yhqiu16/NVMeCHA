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

#include "nvme_io_que_db.h"

//// initialize hash items for sq/cq
//void init_hash_items_sq()
//{
//	for(u32 i = 0; i < NVME_IO_SQ_NUM; i++){
//		g_sqs_attribute[i].qid = 0; // invalid
//		g_sqs_attribute[i].qa_ptr = DB_SQ_BASEADDR + i*SQ_ATTRIBUTE_SIZE; // contiguous address
//	}
//	memset(DB_SQ_BASEADDR, 0, NVME_IO_SQ_NUM*SQ_ATTRIBUTE_SIZE);
//}
//
//void init_hash_items_cq()
//{
//	for(u32 i = 0; i < NVME_IO_CQ_NUM; i++){
//		g_cqs_attribute[i].qid = 0; // invalid
//		g_cqs_attribute[i].qa_ptr = DB_CQ_BASEADDR + i*CQ_ATTRIBUTE_SIZE; // contiguous address
//	}
//	memset(DB_CQ_BASEADDR, 0, NVME_IO_CQ_NUM*CQ_ATTRIBUTE_SIZE);
//}

// initialize sq_attribute/cq_attribute
void init_sqs_attribute()
{
	memset(g_sqs_attribute, 0, NVME_IO_SQ_NUM*SQ_ATTRIBUTE_SIZE);
}


void init_cqs_attribute()
{
	memset(g_cqs_attribute, 0, NVME_IO_CQ_NUM*CQ_ATTRIBUTE_SIZE);
}


// set/get/del sq_attribute/cq_attribute pointer in g_sqs_attribute/g_cqs_attribute
// return TRUE/FALSE
//u32 set_sq_attribute(u16 qid, sq_attribute_t* sqa, u32 *index)
//{
//	if(qid == 0)
//		return FALSE;
//	u32 pos = NVME_IO_SQ_NUM;
//	for(u32 i = 0; i < NVME_IO_SQ_NUM; i++){
//		u16 tmp_id = g_sqs_attribute[i].qid;
//		if(qid == tmp_id){ // already has qid
//			break;
//		} else if(tmp_id == 0){ // select the ahead most
//			pos = i;
//			break;
//		}
//	}
//	if(pos == NVME_IO_SQ_NUM)
//		return FALSE;
//	*index = pos;
//	memcpy(&g_sqs_attribute[pos], sqa, SQ_ATTRIBUTE_SIZE);
//	return TRUE;
//}

// sq index needs to be the same with paired cq
u32 set_sq_attribute(u16 cq_id, sq_attribute_t* sqa, u32 *index)
{
	if(cq_id == 0)
		return FALSE;
	for(u32 i = 0; i < NVME_IO_CQ_NUM; i++){
		if(cq_id == g_cqs_attribute[i].qid){ // find paired CQ
			if(g_sqs_attribute[i].qid == 0){ // the same index
				*index = i;
				memcpy(&g_sqs_attribute[i], sqa, SQ_ATTRIBUTE_SIZE);
				return TRUE;
			} else {
				return FALSE;
			}
		}
	}
	return FALSE;
}


u32 set_cq_attribute(u16 qid, cq_attribute_t* cqa, u32 *index)
{
	if(qid == 0)
		return FALSE;
	u32 pos = NVME_IO_CQ_NUM;
	for(u32 i = 0; i < NVME_IO_CQ_NUM; i++){
		u16 tmp_id = g_cqs_attribute[i].qid;
		if(qid == tmp_id){ // already has qid
			return FALSE;
		} else if((pos == NVME_IO_CQ_NUM) && (tmp_id == 0)){ // select the ahead most
			pos = i; // continue to search qid
		}
	}
	if(pos == NVME_IO_CQ_NUM)
		return FALSE;
	*index = pos;
	memcpy(&g_cqs_attribute[pos], cqa, CQ_ATTRIBUTE_SIZE);
	return TRUE;
}


u32 get_sq_attribute(u16 qid, sq_attribute_t* sqa, u32 *index)
{
	if(qid == 0)
		return FALSE;
	for(u32 i = 0; i < NVME_IO_SQ_NUM; i++){
		if(qid == g_sqs_attribute[i].qid){
			*index = i;
			sqa = &(g_sqs_attribute[i]);
			return TRUE;
		}
	}
	return FALSE;
}

u32 get_cq_attribute(u16 qid, cq_attribute_t* cqa, u32 *index)
{
	if(qid == 0)
		return FALSE;
	for(u32 i = 0; i < NVME_IO_CQ_NUM; i++){
		if(qid == g_cqs_attribute[i].qid){
			*index = i;
			cqa = &(g_cqs_attribute[i]);
			return TRUE;
		}
	}
	return FALSE;
}


u32 del_sq_attribute(u16 qid, u32 *index)
{
	if(qid == 0)
		return FALSE;
	for(u32 i = 0; i < NVME_IO_SQ_NUM; i++){
		if(qid == g_sqs_attribute[i].qid){
			*index = i;
			g_sqs_attribute[i].qid = 0;
			return TRUE;
		}
	}
	return FALSE;
}

u32 del_cq_attribute(u16 qid, u32 *index)
{
	if(qid == 0)
		return FALSE;
	for(u32 i = 0; i < NVME_IO_CQ_NUM; i++){
		if(qid == g_cqs_attribute[i].qid){
			*index = i;
			g_cqs_attribute[i].qid = 0;
			return TRUE;
		}
	}
	return FALSE;
}


// check if sq/cq exist according to qid or index
// return TRUE/FALSE
u32 sq_exist(u16 qid)
{
	if(qid == 0)
		return FALSE;
	for(u32 i = 0; i < NVME_IO_SQ_NUM; i++){
		if(qid == g_sqs_attribute[i].qid){
			return TRUE;
		}
	}
	return FALSE;
}

u32 cq_exist(u16 qid)
{
	if(qid == 0)
		return FALSE;
	for(u32 i = 0; i < NVME_IO_CQ_NUM; i++){
		if(qid == g_cqs_attribute[i].qid){
			return TRUE;
		}
	}
	return FALSE;
}


u32 sq_exist_at_index(u32 index)
{
	if((index < NVME_IO_SQ_NUM) && (g_sqs_attribute[index].qid != 0))
		return TRUE;
	else
		return FALSE;
}

u32 cq_exist_at_index(u32 index)
{
	if((index < NVME_IO_CQ_NUM) && (g_cqs_attribute[index].qid != 0))
		return TRUE;
	else
		return FALSE;
}


// find paired CQ in g_sqs_attribute array
//u32 find_paired_cq(u16 cq_id, u16* sq_id)
//{
//	for(u32 i = 0; i < NVME_IO_SQ_NUM; i++){
//		if((g_sqs_attribute[i].qid != 0) && (g_sqs_attribute[i].cqid == cq_id)){
////			*sqs_index = i;
//			*sq_id = g_sqs_attribute[i].qid;
//			return TRUE;
//		}
//	}
//	return FALSE;
//}


// find paired SQ according to cq_id
//u32 find_paired_sq(u16 cq_id, u16* sq_id)
//{
//	if(cq_id == 0)
//		return FALSE;
//	for(u32 i = 0; i < NVME_IO_CQ_NUM; i++){
//		if(cq_id == g_cqs_attribute[i].qid){
//			if((g_sqs_attribute[i].qid == 0) || (g_sqs_attribute[i].cqid != cq_id)){
//				return FALSE;
//			} else{
//				*sq_id = g_sqs_attribute[i].qid;
//				return TRUE;
//			}
//		}
//	}
//	return FALSE;
//}
