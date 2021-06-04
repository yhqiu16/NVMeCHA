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
 * NVMe Controller Registers
 */


#ifndef __NVME_REGS_H__
#define __NVME_REGS_H__

#define PCI_VENDOR_ID				(0x10ee)
#define PCI_SUBSYSTEM_VENDOR_ID		(0x10ee)
#define PCI_SUBSYSTEM_ID			(0x0007)
#define SERIAL_NUMBER				"NVMe SSD"
#define MODEL_NUMBER				"NVMe SSD"
#define FIRMWARE_REVISION			"NVMe SSD"
#define CONTROLLER_ID               (0x0001)
#define NVME_VERSION                (0x10200)
//#define SUBNQN						"nqn.2020-12.fudan.edu.cn:nvme:nvm-subsystem-sn-d001"

// Controller Capabilities, 0x0 ~ 0x7
typedef union _nvme_reg_cap_t
{
	u32	dw[2];

	struct
	{
		u16	mqes; // RO

		u8	cqr				:1; // RO
		u8	ams				:2; // RO
		u8	reserved0		:5; // RO
		u8	to;   // RO

		u16	dstrd			:4; // RO
		u16	nssrs			:1; // RO
		u16	css				:8; // RO
		u16	bps				:1; // RO
		u16	reserved1		:2; // RO

		u8	mpsmin			:4; // RO
		u8	mpsmax			:4; // RO

		u8  pmrs            :1; // RO
		u8  cmbs            :1; // RO
		u8	reserved2       :6; // RO
	};
} nvme_reg_cap_t;

// Version, 0x08 ~ 0x0B
typedef union _nvme_reg_vs_t
{
	u32	dw;

	struct
	{
		u8	ter; // RO
		u8	mnr; // RO
		u16	mjr; // RO
	};
} nvme_reg_vs_t;

// Interrupt Mask Set, 0x0C ~ 0x0F
typedef union _nvme_reg_intms_t
{
	u32	dw;

	u32	ivms; // RWS
} nvme_reg_intms_t;

// Interrupt Mask Clear, 0x10 ~ 0x13
typedef union _nvme_reg_intmc_t
{
	u32	dw;

	u32	ivmc; // RWC
} nvme_reg_intmc_t;

// Controller Configuration, 0x14 ~ 0x17
typedef union _nvme_reg_cc_t
{
	u32	dw;

	struct
	{
		u16	en				:1; // RW
		u16	reserved0		:3; // RO
		u16	css				:3; // RW
		u16	mps				:4; // RW
		u16	ams				:3; // RW
		u16	shn				:2; // RW

		u8	iosqes			:4; // RW/RO
		u8	iocqes			:4; // RW/RO

		u8	reserved1;          // RO
	};
} nvme_reg_cc_t;

// Reserved, 0x18 ~ 0x1B

// Controller Status, 0x1C ~ 0x1F
typedef union _nvme_reg_csts_t
{
	u32	dw;

	struct
	{
		u32	rdy				:1; // RO
		u32	cfs				:1; // RO
		u32	shst			:2; // RO
		u32	nssro			:1; // RWC
		u32	pp				:1; // RO
		u32	reserved0		:26;// RO

	};
} nvme_reg_csts_t;

// NVM Subsystem Reset (Optional), 0x20 ~ 0x23
typedef union _nvme_reg_nssr_t
{
	u32	dw;

	u32	nssrc; // RW
} nvme_reg_nssr_t;

// Admin Queue Attributes, 0x24 ~ 0x27
typedef union _nvme_reg_aqa_t
{
	u32	dw;

	struct
	{
		u16	asqs			:12; // RW
		u16	reserved0		:4;  // RO

		u16	acqs			:12; // RW
		u16	reserved1		:4;  // RO
	};
} nvme_reg_aqa_t;

// Admin Submission Queue Base Address, 0x28 ~ 0x2F
typedef union _nvme_reg_asq_t
{
	u32	dw[2];

	u64	asqb; // RW/RO, bit[11:0] = 0

	struct
	{
		u32	reserved0		:12; // RO
		u32	asqb_low		:20; // RW

		u32	asqb_high;           // RW
	};
} nvme_reg_asq_t;

// Admin Completion Queue Base Address, 0x30 ~ 0x37
typedef union _nvme_reg_acq_t
{
	u32	dw[2];

	u64	acqb; // RW/RO, bit[11:0] = 0

	struct
	{
		u32	reserved0		:12; // RO
		u32	acqb_low		:20; // RW

		u32	acqb_high;           // RW
	};
} nvme_reg_acq_t;

// Controller Memory Buffer Location (Optional), 0x38 ~ 0x3B
typedef union _nvme_reg_cmbloc_t
{
	u32	dw;

	struct
	{
		u32	bir				:3; // RO
		u32 cqmms           :1; // RO
		u32 cqpds           :1; // RO
		u32 cdpmls          :1; // RO
		u32 cdpcils         :1; // RO
		u32 cdmmms          :1; // RO
		u32 cqda            :1; // RO
		u32	reserved0		:3; // RO
		u32	ofst			:20;// RO
	};
} nvme_reg_cmbloc_t;

// Controller Memory Buffer Size (Optional), 0x3C ~ 0x3F
typedef union _nvme_reg_cmbsz_t
{
	u32	dw;

	struct
	{
		u32	sqs				:1; // RO
		u32	cqs				:1; // RO
		u32	lists			:1; // RO
		u32	rds				:1; // RO
		u32	wds				:1; // RO
		u32	reserved0		:3; // RO
		u32	szu				:4; // RO
		u32	sz				:20;// RO
	};
} nvme_reg_cmbsz_t;

// Boot Partition Information (Optional), 0x40 ~ 0x43
typedef union _nvme_reg_bpinfo_t
{
	u32	dw;

	struct
	{
		u32	bpsz			:15; // RO
		u32	reserved0		:9;  // RO
		u32	brs				:2;  // RO
		u32	reserved1		:5;  // RO
		u32	abpid			:1;  // RO
	};
} nvme_reg_bpinfo_t;

// Boot Partition Read Select (Optional), 0x44 ~ 0x47
typedef union _nvme_reg_bprsel_t
{
	u32	dw;

	struct
	{
		u32	bprsz			:10; // RW
		u32	bprof			:20; // RW
		u32	reserved0		:1;  // RO
		u32	bpid			:1;  // RW
	};
} nvme_reg_bprsel_t;

// Boot Partition Memory Buffer Location (Optional), 0x48 ~ 0x4F
typedef union _nvme_reg_bpmbl_t
{
	u32	dw[2];

	u64	bmbba;

	struct
	{
		u32	reserved0		:12; // RO
		u32	bmbba_low		:20; // RW

		u32	bmbba_high;          // RW
	};
} nvme_reg_bpmbl_t;

// Controller Memory Buffer Space Control, 0x50 ~ 0x57
typedef union _nvme_reg_cmbmsc_t
{
	u32	dw[2];

	u64	cba;

	struct
	{
		u32	cre        		:1;  // RW
		u32	cmse       		:1;  // RW
		u32	reserved0		:10; // RO
		u32	cba_low 		:20; // RW

		u32	cba_high;          // RW
	};
} nvme_reg_cmbmsc_t;

// Controller Memory Buffer Status, 0x58 ~ 0x61
typedef union _nvme_reg_cmbsts_t
{
	u32	dw;

	struct
	{
		u32	cbai        	:1;  // RO
		u32	reserved0		:31; // RO
	};
} nvme_reg_cmbsts_t;


typedef union _nvme_reg_t
{
	u32	dw[20];

	struct
	{
		// Controller Capabilities, 0x00 ~ 0x07
		nvme_reg_cap_t cap;

		// Version, 0x08 ~ 0x0B
		nvme_reg_vs_t vs;

		// Interrupt Mask Set, 0x0C ~ 0x0F
		nvme_reg_intms_t intms;

		// Interrupt Mask Clear, 0x10 ~ 0x13
		nvme_reg_intmc_t intmc;

		// Controller Configuration, 0x14 ~ 0x17
		nvme_reg_cc_t cc;

		// Reserved, 0x18 ~ 0x1B
		u8	reserved0[4];

		// Controller Status, 0x1C ~ 0x1F
		nvme_reg_csts_t csts;

		// NVM Subsystem Reset (Optional), 0x20 ~ 0x23
		nvme_reg_nssr_t nssr;

		// Admin Queue Attributes, 0x24 ~ 0x27
		nvme_reg_aqa_t aqa;

		// Admin Submission Queue Base Address, 0x28 ~ 0x2F
		nvme_reg_asq_t asq;

		// Admin Completion Queue Base Address, 0x30 ~ 0x37
		nvme_reg_acq_t acq;

		// Controller Memory Buffer Location (Optional), 0x38 ~ 0x3B
		nvme_reg_cmbloc_t cmbloc;

		// Controller Memory Buffer Size (Optional), 0x3C ~ 0x3F
		nvme_reg_cmbsz_t cmbsz;

		// Boot Partition Information (Optional), 0x40 ~ 0x43
		nvme_reg_bpinfo_t bpinfo;

		// Boot Partition Read Select (Optional), 0x44 ~ 0x47
		nvme_reg_bprsel_t bprsel;

		// Boot Partition Memory Buffer Location (Optional), 0x48 ~ 0x4F
		nvme_reg_bpmbl_t bpmbl;

		// Controller Memory Buffer Space Control, 0x50 ~ 0x57
		nvme_reg_cmbmsc_t cmbmsc;

		// Controller Memory Buffer Status, 0x58 ~ 0x61
		nvme_reg_cmbsts_t cmbsts;
	};
} nvme_reg_t;


// Command Sets Supported (CSS)
typedef enum _NVME_REG_CAP_CSS_E
{
	NVME_REG_CAP_CSS_BIT_NVM_COMMAND_SET				= 0x01,
} NVME_REG_CAP_CSS_E;

// Arbitration Mechanism Supported (AMS)
typedef enum _NVME_REG_CAP_AMS_E
{
	NVME_REG_CAP_AMS_BIT_WEIGHTED_ROUND_ROBIN			= 0x01,
	NVME_REG_CAP_AMS_BIT_VENDOR_SPECIFIC				= 0x02,
} NVME_REG_CAP_AMS_E;

// Shutdown Notification (SHN)
typedef enum _NVME_REG_CC_SHN_E
{
	NVME_REG_CC_SHN_NO_NOTIFICATION						= 0x0,
	NVME_REG_CC_SHN_NORMAL_SHUTDOWN_NOTIFICATION		= 0x1,
	NVME_REG_CC_SHN_ABRUPT_SHUTDOWN_NOTIFICATION		= 0x2,
} NVME_REG_CC_SHN_E;

// Arbitration Mechanism Selected (AMS)
typedef enum _NVME_REG_CC_AMS_E
{
	NVME_REG_CC_AMS_ROUND_ROBIN							= 0x0,
	NVME_REG_CC_AMS_WEIGHTED_ROUND_ROBIN				= 0x1,
	NVME_REG_CC_AMS_VENDOR_SPECIFIC						= 0x7,
} NVME_REG_CC_AMS_E;

// I/O Command Set Selected (CSS)
typedef enum _NVME_REG_CC_CSS_E
{
	NVME_REG_CC_CSS_NVM_COMMAND_SET						= 0x0,
} NVME_REG_CC_CSS_E;

// Shutdown Status (SHST)
typedef enum _NVME_REG_CSTS_SHST_E
{
	NVME_REG_CSTS_SHST_NORMAL_OPERATION					= 0x0,
	NVME_REG_CSTS_SHST_PROCESSING_OCCURRING				= 0x1,
	NVME_REG_CSTS_SHST_PROCESSING_COMPLETE				= 0x2,
} NVME_REG_CSTS_SHST_E;

// Size Units (SZU)
typedef enum _NVME_REG_CMBSZ_SZU_E
{
	NVME_REG_CMBSZ_SZU_4KB								= 0x0,
	NVME_REG_CMBSZ_SZU_64KB								= 0x1,
	NVME_REG_CMBSZ_SZU_1MB								= 0x2,
	NVME_REG_CMBSZ_SZU_16MB								= 0x3,
	NVME_REG_CMBSZ_SZU_256MB							= 0x4,
	NVME_REG_CMBSZ_SZU_4GB								= 0x5,
	NVME_REG_CMBSZ_SZU_64GB								= 0x6,
} NVME_REG_CMBSZ_SZU_E;

// Boot Read Status (BRS):
typedef enum _NVME_REG_BPINFO_BRS_E
{
	NVME_REG_BPINFO_BRS_NO_READ_REQUESTED				= 0x0,
	NVME_REG_BPINFO_BRS_READ_IN_PROGRESS				= 0x1,
	NVME_REG_BPINFO_BRS_READ_COMPLETED_SUCCESSFULLY		= 0x2,
} NVME_REG_BPINFO_BRS_E;


#endif
