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
 * NVMe Data Structures
 * Refer to OpenExpress
 */

#ifndef __NVME_STRUCTS_H__
#define __NVME_STRUCTS_H__

#include "xil_types.h"

#define NVME_ADMIN_QUE_INDEX	(0)

#define NVME_IO_SQ_NUM			(8)
#define NVME_IO_CQ_NUM			(8)

#define NVME_SQ_NUM				(NVME_IO_SQ_NUM + 1)
#define NVME_CQ_NUM				(NVME_IO_CQ_NUM + 1)

#define NVME_SQ_ENTRY_SIZE		(0x40)
#define NVME_CQ_ENTRY_SIZE		(0x10)
#define NVME_QUE_MAX_SIZE		(0xFFF)

#define NVME_MSIX_EN			(1)
#define NVME_MSIX_TABLE_SIZE	(16)

#define MIN(X, Y)		(((X) < (Y))? (X) : (Y))
#define MAX(X, Y)		(((X) > (Y))? (X) : (Y))

typedef union _nvme_sq_entry_t
{
	u32	dw[16];

	struct
	{
		// cdw0
		u32	opc				:8;
		u32	fuse			:2;
		u32	reserved0		:4;
		u32	psdt			:2;
		u32	cid				:16;

		u32	nsid;      // cdw1
		u64	reserved1; // cdw2-3
		u64	mptr;      // cdw4-5

		union // cdw6-9
		{
			u32	dptr[4];

			struct
			{
				u64	prp1;
				u64	prp2;
			};

			u32	sgl1[4];
		};

		u32	cdw10; // cdw10, vendor specific
		u32	cdw11; // cdw11, vendor specific

		u32	cdw12;
		u32	cdw13;
		u32	cdw14;
		u32	cdw15;
	};
} nvme_sq_entry_t;

typedef union _nvme_cq_entry_t
{
	u32	dw[4];

	struct
	{
		u32	command_specific;

		u32	reserved0;

		u16	sqhd;
		u16	sqid;

		u16	cid;
		union
		{
			u16	status;
			struct
			{
				u16	phase_tag				:1;
				u16	sc						:8;
				u16	sct						:3;
				u16	crd						:2;
				u16	more					:1;
				u16	dnr						:1;
			};
		};
	};
} nvme_cq_entry_t;

typedef union _nvme_sq_create_io_cq_dw10_t
{
	u32	dw;

	struct
	{
		u16	qid;
		u16	qsize;
	};
} nvme_sq_create_io_cq_dw10_t;


typedef union _nvme_sq_create_io_cq_dw11_t
{
	u32	dw;

	struct
	{
		u16	pc      		:1;
		u16	ien				:1;
		u16	reserved0		:14;
		u16	iv;
	};
} nvme_sq_create_io_cq_dw11_t;


typedef union _nvme_sq_create_io_sq_dw10_t
{
	u32	dw;

	struct
	{
		u16	qid;
		u16	qsize;
	};
} nvme_sq_create_io_sq_dw10_t;


typedef union _nvme_sq_create_io_sq_dw11_t
{
	u32	dw;

	struct
	{
		u16	pc      		:1;
		u16	qprio			:2;
		u16	reserved0		:13;
		u16	cqid;
	};
} nvme_sq_create_io_sq_dw11_t;


typedef union _nvme_sq_delete_io_que_dw10_t
{
	u32	dw;

	struct
	{
		u16	qid;
		u16	reserved;
	};
} nvme_sq_delete_io_que_dw10_t;




typedef union _nvme_sq_get_log_page_dw10_t
{
	u32	dw;

	struct
	{
		u8	lid;

		u8	lsp				:4;
		u8	reserved0		:3;
		u8	rae				:1;

		u16	numdl;
	};
} nvme_sq_get_log_page_dw10_t;


typedef union _nvme_sq_get_log_page_dw11_t
{
	u32	dw;

	struct
	{
		u16	numdu;
		union
		{
			u8 endurance_group_id;
			u8 nvm_set_id;
		};
	};
} nvme_sq_get_log_page_dw11_t;

typedef union _nvme_sq_get_log_page_dw12_t
{
	u32	dw;

	u32	lpol;
} nvme_sq_get_log_page_dw12_t;

typedef union _nvme_sq_get_log_page_dw13_t
{
	u32	dw;

	u32	lpou;
} nvme_sq_get_log_page_dw13_t;




typedef union _nvme_sq_identify_dw10_t
{
	u32	dw;

	struct
	{
		u8	cns;
		u8	reserved0;
		u16	cntid;
	};
} nvme_sq_identify_dw10_t;


typedef union _nvme_sq_set_features_arbitration_dw11_t
{
	u32	dw;

	struct
	{
		u8	ab			:3;
		u8  reserved0	:5;
		u8  lpw;
		u8  mpw;
		u8  hpw;
	};
} nvme_sq_set_features_arbitration_dw11_t;

typedef union _nvme_sq_set_features_power_management_dw11_t
{
	u32	dw;

	struct
	{
		u32	ps			:5;
		u32 wh			:3;
		u32 reserved0	:24;
	};
} nvme_sq_set_features_power_management_dw11_t;

typedef union _nvme_sq_set_features_auto_power_state_transition_dw11_t
{
	u32	dw;

	struct
	{
		u32	apste		:1;
		u32 reserved0	:31;
	};
} nvme_sq_set_features_auto_power_state_transition_dw11_t;


typedef union _nvme_sq_set_features_number_of_queues_dw11_t
{
	u32	dw;

	struct
	{
		u16	nsqr;
		u16	ncqr;
	};
} nvme_sq_set_features_number_of_queues_dw11_t;

typedef union _nvme_sq_set_feature_dw10_t
{
	u32	dw;

	struct
	{
		u32	fid				:8;
		u32	reserved0		:23;
		u32	sv				:1;
	};
} nvme_sq_set_feature_dw10_t;



typedef union _nvme_sq_get_feature_dw10_t
{
	u32	dw;

	struct
	{
		u32	fid				:8;
		u32	sel				:3;
		u32	reserved0		:21;
	};
} nvme_sq_get_feature_dw10_t;



typedef union _nvme_sq_write_dw10_t
{
	u32	dw;

	u32	slba_low;
} nvme_sq_write_dw10_t;

typedef union _nvme_sq_write_dw11_t
{
	u32	dw;

	u32	slba_high;
} nvme_sq_write_dw11_t;

typedef union _nvme_sq_write_dw12_t
{
	u32	dw;

	struct
	{
		u16	nlb;

		u8	reserved0		:4;
		u8	dtype			:4;

		u8	reserved1		:2;
		u8	prinfo			:4;
		u8	fua				:1;
		u8	lr				:1;
	};

	struct
	{
		u32	no_named0		:26;
		u32	prchk			:3;
		u32	pract			:1;
		u32	no_named1		:2;
	};

	struct
	{
		u32	no_named2					:26;
		u32	check_reference_tag			:1;
		u32	check_application_tag		:1;
		u32	check_guard					:1;
		u32	no_named3					:3;
	};
} nvme_sq_write_dw12_t;

typedef union _nvme_sq_write_dw13_t
{
	u32	dw;

	struct
	{
		union
		{
			u8	dsm;

			struct
			{
				u8	af						:4;
				u8	al						:2;
				u8	sequential_request		:1;
				u8	incompressible			:1;
			};
		};

		u8	reserved0;
		u16	dspec;
	};
} nvme_sq_write_dw13_t;

typedef union _nvme_sq_write_dw14_t
{
	u32	dw;

	u32	ilbrt;
} nvme_sq_write_dw14_t;

typedef union _nvme_sq_write_dw15_t
{
	u32	dw;

	struct
	{
		u16	lbatm;
		u16	lbat;
	};
} nvme_sq_write_dw15_t;



typedef union _nvme_sq_read_dw10_t
{
	u32	dw;

	u32	slba_low;
} nvme_sq_read_dw10_t;

typedef union _nvme_sq_read_dw11_t
{
	u32	dw;

	u32	slba_high;
} nvme_sq_read_dw11_t;

typedef union _nvme_sq_read_dw12_t
{
	u32	dw;

	struct
	{
		u16	nlb;

		u16	reserved0		:10;
		u16	prinfo			:4;
		u16	fua				:1;
		u16	lr				:1;
	};

	struct
	{
		u32	no_named0		:26;
		u32	prchk			:3;
		u32	pract			:1;
		u32	no_named1		:2;
	};

	struct
	{
		u32	no_named2					:26;
		u32	check_reference_tag			:1;
		u32	check_application_tag		:1;
		u32	check_guard					:1;
		u32	no_named3					:3;
	};
} nvme_sq_read_dw12_t;

typedef union _nvme_sq_read_dw13_t
{
	u32	dw;

	struct
	{
		union
		{
			u8	dsm;

			struct
			{
				u8	af						:4;
				u8	al						:2;
				u8	sequential_request		:1;
				u8	incompressible			:1;
			};
		};

		u8	reserved0[3];
	};
} nvme_sq_read_dw13_t;

typedef union _nvme_sq_read_dw14_t
{
	u32	dw;

	u32	eilbrt;
} nvme_sq_read_dw14_t;

typedef union _nvme_sq_read_dw15_t
{
	u32	dw;

	struct
	{
		u16	elbatm;
		u16	elbat;
	};
} nvme_sq_read_dw15_t;



typedef union _nvme_identify_power_state_desc_t
{
    u32  dw[8];

    struct
    {
        u16  mp;
        u8   reserved0;
        u8   mxps                :1;
        u8   nops                :1;
        u8   reserved1           :6;

        u32  enlat;
        u32  exlat;

        u8   rrt                 :5;
        u8   reserved2           :3;

        u8   rrl                 :5;
        u8   reserved3           :3;

        u8   rwt                 :5;
        u8   reserved4           :3;

        u8   rwl                 :5;
        u8   reserved5           :3;

        u16  idlp;

        u8   reserved6           :6;
        u8   ips                 :2;

        u8   reserved7;

        u16  actp;

        u8   apw                 :3;
        u8   reserved8           :3;
        u8   aps                 :2;

        u8   reserved9[9];
    };
} nvme_identify_power_state_desc_t;

typedef union _nvme_identify_controller_data_t
{
	u32	dw[1024];

	struct
	{
		u16	vid;
		u16	ssvid;
		u8	sn[20];
		u8	mn[40];
		u8	fr[8];
		u8	rab;
		u8	ieee[3];

		union
		{
			u8	cmic;

			struct
			{
				u8	multi_subsystem_port	:1;
				u8	multi_controller		:1;
				u8	sr_iov					:1;
				u8  asymmetric_ns_access_rpt:1;
				u8	cmic_reserved0			:4;
			};
		};

		u8	mdts;
		u16	cntlid;
		u32	ver;
		u32	rtd3r;
		u32	rtd3e;

		union
		{
			u32	oaes;

			struct
			{
				u32	oaes_reserved0					:8;
				u32	namespace_attribute_notices		:1;
				u32	firmware_activation_notices		:1;
				u32	oaes_reserved1					:1;
				u32 asymmetric_namespace_access		:1;
				u32 predictable_latency_event		:1;
				u32 lba_status_info					:1;
				u32 endurance_group_event			:1;
				u32 oaes_reserved2					:17;
			};
		};

		union
		{
			u32	ctratt;

			struct
			{
				u32	host_id_128bit									:1;
				u32	non_operational_power_state_permissive_mode		:1;
				u32 nvm_sets										:1;
				u32 read_recovery_levels							:1;
				u32 endurance_groups								:1;
				u32 predictable_latency_mode						:1;
				u32 traffic_based_keep_alive_support				:1;
				u32 namespace_granularity							:1;
				u32 sq_associations									:1;
				u32 uuid_list										:1;
				u32	ctratt_reserved0								:22;
			};
		};

		u16 rrls;
		u8	reserved0[9];
		u8  cntrltype;
		u8	fguid[16];
		u16 crdt1;
		u16 crdt2;
		u16 crdt3;
		u8	reserved1[106];
		u8	management_interface[16];


		union
		{
			u16	oacs;

			struct
			{
				u16	security_send_and_receive		:1;
				u16	format_nvm						:1;
				u16	firmware_commit_and_download	:1;
				u16	namespace_management			:1;
				u16	device_self_test				:1;
				u16	directives						:1;
				u16	nvme_mi_send_receive			:1;
				u16	virtualization_management		:1;
				u16	doorbell_buffer_config			:1;
				u16 get_lba_status					:1;
				u16	oacs_reserved0					:6;
			};
		};

		u8	acl;
		u8	aerl;

		union
		{
			u8	frmw;

			struct
			{
				u8	first_firmware_slot_read_only			:1;
				u8	number_of_firmware_slots				:3;
				u8	firmware_activation_without_reset		:1;
				u8	frmw_reserved0							:3;
			};
		};

		union
		{
			u8	lpa;

			struct
			{
				u8	smart_health_info_log_page				:1;
				u8	command_supported_and_effects_log_page	:1;
				u8	extended_data_for_log_page				:1;
				u8	telemetry_initiated_log_page			:1;
				u8  persistent_event_log					:1;
				u8	lpa_reserved0							:3;
			};
		};

		u8	elpe;
		u8	npss;

		union
		{
			u8	avscc;

			struct
			{
				u8	default_format_for_admin_vendor			:1;
				u8	avscc_reserved0							:7;
			};
		};

		union
		{
			u8	apsta;

			struct
			{
				u8	auto_power_state_transition				:1;
				u8	apsta_reserved0							:7;
			};
		};

		u16	wctemp;
		u16	cctemp;
		u16	mtfa;
		u32	hmpre;
		u32	hmmin;
		u32	tnvmcap[4];
		u32	unvmcap[4];

		union
		{
			u32	rpmbs;

			struct
			{
				u16	number_of_rpmb_units		:3;
				u16	authentication_method		:3;
				u16	rpmbs_reserved0				:10;
				u8	total_size;
				u8	access_size;
			};
		};

		u16	edstt;

		union
		{
			u8	dsto;

			struct
			{
				u8	only_one_device_self_test	:1;
				u8	dsto_reserved0				:7;
			};
		};

		u8	fwug;
		u16	kas;

		union
		{
			u16	hctma;

			struct
			{
				u16	host_controlled_thermal_management	:1;
				u16	hctma_reserved0						:15;
			};
		};

		u16	mntmt;
		u16	mxtmt;

		union
		{
			u32	sanicap;

			struct
			{
				u32	crypto_erase_sanitize		:1;
				u32	block_erase_sanitize		:1;
				u32	overwrite_sanitize			:1;
				u32	sanicap_reserved0			:26;
				u32 no_deallocate_inhibited		:1;
				u32 no_deallocate_modifies_media:2;
			};
		};

		u32 hmminds;
		u16 hmmaxd;
		u16 nsetidmax;
		u16 endgidmax;
		u8  anatt;

		union
		{
			u8 anacap;

			struct
			{
				u8  ana_optimized			:1;
				u8  ana_non_optimized		:1;
				u8  ana_inaccessible		:1;
				u8  ana_persistent_loss		:1;
				u8  ana_change				:1;
				u8  anacap_reserved0		:1;
				u8  anagrpid_not_change		:1;
				u8  anagrpid_non_zero		:1;
			};
		};

		u32 anagrpmax;
		u32 nanagrpid;
		u32 pels;

		u8	reserved2[156];

		union
		{
			u8	sqes;

			struct
			{
				u8	maximum_sq_entry_size		:4;
				u8	required_sq_entry_size		:4;
			};
		};

		union
		{
			u8	cqes;

			struct
			{
				u8	maximum_cq_entry_size		:4;
				u8	required_cq_entry_size		:4;
			};
		};

		u16	maxcmd;
		u32	nn;

		union
		{
			u16	oncs;

			struct
			{
				u16	compare						:1;
				u16	write_uncorrectable			:1;
				u16	dataset_management			:1;
				u16	write_zeroes				:1;
				u16	save_field_for_feature		:1;
				u16	reservation					:1;
				u16	timestamp					:1;
				u16 verify						:1;
				u16	oncs_reserved0				:8;
			};
		};

		union
		{
			u16	fuses;

			struct
			{
				u16	compare_and_write_fused		:1;
				u16	fuses_reserved0				:15;
			};
		};

		union
		{
			u8	fna;

			struct
			{
				u8	format_apply_to_all_namespaces			:1;
				u8	secure_erase_apply_to_all_namespaces	:1;
				u8	cryptographic_erase						:1;
				u8	fna_reserved0							:5;
			};
		};

		union
		{
			u8	vwc;

			struct
			{
				u8	volatile_write_cache		:1;
				u8  flush_behavior				:2;
				u8	vwc_reserved0				:5;
			};
		};

		u16	awun;
		u16	awupf;

		union
		{
			u8	nvscc;

			struct
			{
				u8	default_format_for_nvm_vendor		:1;
				u8	reserved20							:7;
			};
		};

		union
		{
			u8	nwpc;

			struct
			{
				u8  no_write_protect					:1;
				u8  write_protect_until_power_cycle		:1;
				u8  permanent_write_protect				:1;
				u8  nwpc_reserved0						:5;
			};
		};

		u16	acwu;
		u16	reserved3;

		union
		{
			u32	sgls;

			struct
			{
				u32	support_type								:2;
				u32	keyed_sgl_data_block						:1;
				u32	sgls_reserved0								:13;
				u32	bit_bucket									:1;
				u32	contiguous_physical_buffer_for_metadata		:1;
				u32	larger_data_than_to_be_transferred			:1;
				u32	metadata_pointer_contain_sgl_segment		:1;
				u32	address_field_specify_offset				:1;
				u32	transport_sgl_data_block					:1;
				u32	sgls_reserved1								:10;
			};
		};

		u32 mnan;

		u8	reserved4[224];
		u8	subnqn[256];
		u8	reserved5[768];
		u8	nvme_over_fabrics[256];

		nvme_identify_power_state_desc_t psd[32];

		u8	vendor_specific[1024];

	};
} nvme_identify_controller_data_t;




typedef union _nvme_identify_lba_format_t
{
	u32	dw;

	struct
	{
		u16	ms;
		u8	lbads;
		u8	rp				:2;
		u8	reserved0		:6;
	};
} nvme_identify_lba_format_t;


typedef union _nvme_identify_namespace_data_t
{
	u32	dw[1024];

	struct
	{
		u64	nsze;
		u64	ncap;
		u64	nuse;

		union
		{
			u8	nsfeat;

			struct
			{
				u8	thin_provisioning		:1;
				u8	namespace_atomic		:1;
				u8	deallocated				:1;
				u8	unique_id				:1;
				u8  io_optimization			:1;
				u8	reserved0				:3;
			};
		};

		u8	nlbaf;

		union
		{
			u8	flbas;

			struct
			{
				u8	lba_format_index			:4;
				u8	contiguous_metadata_buffer	:1;
				u8	reserved1					:3;
			};

		};

		union
		{
			u8	mc;

			struct
			{
				u8	metadata_as_part_of_extened_data_lba	:1;
				u8	meatadata_pointer						:1;
				u8	reserved2								:6;
			};
		};

		union
		{
			u8	dpc;

			struct
			{
				u8	protection_information_type_1		:1;
				u8	protection_information_type_2		:1;
				u8	protection_information_type_3		:1;
				u8	first_eight_bytes_of_metadata		:1;
				u8	last_eight_bytes_of_metadata		:1;
				u8	reserved3							:3;
			};
		};

		union
		{
			u8	dps;

			struct
			{
				u8	protection_information				:3;
				u8	first_eight_bytes_enable			:1;
				u8	reserved4							:4;
			};

		};

		union
		{
			u8	nmic;

			struct
			{
				u8	namespace_sharing		:1;
				u8	reserved5				:7;
			};

		};

		union
		{
			u8	rescap;

			struct
			{
				u8	persist_through_power_loss			:1;
				u8	write_exclusive_reservation			:1;
				u8	exclusive_access_reservation		:1;
				u8	write_exclusive_registrants_only	:1;
				u8	exclusive_access_registrants_only	:1;
				u8	write_exclusive_all_registrants		:1;
				u8	exclusive_access_all_registrants	:1;
				u8	ignore_existing_key_revision_1_3	:1;
			};
		};

		union
		{
			u8	fpi;

			struct
			{
				u8	remained_percentage_of_format_nvm	:7;
				u8	format_progress_indicator			:1;
			};
		};

		union
		{
			u8	dlfeat;

			struct
			{
				u8	deallocated_value				:3;
				u8	deallocate_bit_in_write_zeros	:1;
				u8	crc_for_guard_field				:1;
				u8	reserved6						:3;
			};
		};

		u16	nawun;
		u16	nawupf;
		u16	nacwu;
		u16	nabsn;
		u16	nabo;
		u16	nabspf;
		u16	noiob;
		u64	nvmcap[2];
		u16 npwg;
		u16 npwa;
		u16 npdg;
		u16 npda;
		u16 npws;
		u8	reserved7[18];
		u32 anagrpid;
		u8  reserved8[3];

		union
		{
			u8  nsattr;

			struct
			{
				u8  currently_write_protected	:1;
				u8  reserved9					:7;
			};
		};

		u16 nvmsetid;
		u16 endgid;

		u8	nguid[16];
		u8	eui64[8];

		nvme_identify_lba_format_t lba_format[16];

		u8	reserved10[192];
		u8	vendor_specific[3712];
	};
} nvme_identify_namespace_data_t;



typedef union _nvme_namespace_list_t
{
	u32	dw[1024];

	u32	identifier[1024];
} nvme_namespace_list_t;

// Opcodes for Admin Commands
typedef enum _NVME_ADMIN_OPCODE_E
{
	NVME_ADMIN_OPCODE_DELETE_IO_SQ					= 0x00,
	NVME_ADMIN_OPCODE_CREATE_IO_SQ					= 0x01,
	NVME_ADMIN_OPCODE_GET_LOG_PAGE					= 0x02,
	NVME_ADMIN_OPCODE_DELETE_IO_CQ					= 0x04,
	NVME_ADMIN_OPCODE_CREATE_IO_CQ					= 0x05,
	NVME_ADMIN_OPCODE_IDENTIFY						= 0x06,
	NVME_ADMIN_OPCODE_ABORT							= 0x08,
	NVME_ADMIN_OPCODE_SET_FEATURE					= 0x09,
	NVME_ADMIN_OPCODE_GET_FEATURE					= 0x0A,
	NVME_ADMIN_OPCODE_ASYNCHRONOUS_EVENT			= 0x0C,
	NVME_ADMIN_OPCODE_NAMESPACE_MANAGEMENT			= 0x0D,
	NVME_ADMIN_OPCODE_FIRMWARE_COMMIT				= 0x10,
	NVME_ADMIN_OPCODE_FIRMWARE_DOWNLOAD				= 0x11,
	NVME_ADMIN_OPCODE_DEVICE_SELF_TEST				= 0x14,
	NVME_ADMIN_OPCODE_NAMESPACE_ATTACHMENT			= 0x15,
	NVME_ADMIN_OPCODE_KEEP_ALIVE					= 0x18,
	NVME_ADMIN_OPCODE_DIRECTIVE_SEND				= 0x19,
	NVME_ADMIN_OPCODE_DIRECTIVE_RECEIVE				= 0x1A,
	NVME_ADMIN_OPCODE_VIRTUALIZATION_MANAGEMENT		= 0x1C,
	NVME_ADMIN_OPCODE_MI_SEND						= 0x1D,
	NVME_ADMIN_OPCODE_MI_RECEIVE					= 0x1E,
	NVME_ADMIN_OPCODE_DOORBELL_BUFFER_CONFIG		= 0x7F,
	NVME_ADMIN_OPCODE_FORMAT						= 0x80,
	NVME_ADMIN_OPCODE_SECURITY_SEND					= 0x81,
	NVME_ADMIN_OPCODE_SECURITY_RECEIVE				= 0x82,
	NVME_ADMIN_OPCODE_SANITIZE						= 0x84,
} NVME_ADMIN_OPCODE_E;



// Opcodes for NVM Commands
typedef enum _NVME_NVM_OPCODE_E
{
	NVME_NVM_OPCODE_FLUSH							= 0x00,
	NVME_NVM_OPCODE_WRITE							= 0x01,
	NVME_NVM_OPCODE_READ							= 0x02,
	NVME_NVM_OPCODE_WRITE_UNCORRECTABLE				= 0x04,
	NVME_NVM_OPCODE_COMPARE							= 0x05,
	NVME_NVM_OPCODE_WRITE_ZEROES					= 0x08,
	NVME_NVM_OPCODE_DATASET_MANAGEMENT				= 0x09,
	NVME_NVM_OPCODE_RESERVATION_REGISTER			= 0x0D,
	NVME_NVM_OPCODE_RESERVATION_REPORT				= 0x0E,
	NVME_NVM_OPCODE_RESERVATION_ACQUIRE				= 0x11,
	NVME_NVM_OPCODE_RESERVATION_RELEASE				= 0x15,
} NVME_NVM_OPCODE_E;



// Feature Identifiers
typedef enum _NVME_FEATURE_ID_E
{
	NVME_FEATURE_ID_ARBITRATION						= 0x01,
	NVME_FEATURE_ID_POWER_MANAGEMENT				= 0x02,
	NVME_FEATURE_ID_LBA_RANGE_TYPE					= 0x03,
	NVME_FEATURE_ID_TEMPERATURE_THRESHOLD			= 0x04,
	NVME_FEATURE_ID_ERROR_RECOVERY					= 0x05,
	NVME_FEATURE_ID_VOLATILE_WRITE_CACHE			= 0x06,
	NVME_FEATURE_ID_NUMBER_OF_QUEUE					= 0x07,
	NVME_FEATURE_ID_INTERRUPT_COALESCING			= 0x08,
	NVME_FEATURE_ID_INTERRUPT_VECTOR_CONFIG			= 0x09,
	NVME_FEATURE_ID_WRITE_ATOMICITY_NORMAL			= 0x0A,
	NVME_FEATURE_ID_ASYNCHRONOUS_EVENT_CONFIG		= 0x0B,
	NVME_FEATURE_ID_AUTO_POWER_STATE_TRANSITION		= 0x0C,
	NVME_FEATURE_ID_HOST_MEMORY_BUFFER				= 0x0D,
	NVME_FEATURE_ID_TIMESTAMP						= 0x0E,
	NVME_FEATURE_ID_KEEP_ALIVE_TIMER				= 0x0F,
	NVME_FEATURE_ID_HOST_THERMAL_MANAGEMENT			= 0x10,
	NVME_FEATURE_ID_NON_OPERATIONAL_POWER_CONFIG	= 0x11,

	NVME_FEATURE_ID_SOFTWARE_PROGRESS_MARKER		= 0x80,
	NVME_FEATURE_ID_HOST_ID							= 0x81,
	NVME_FEATURE_ID_RESERVATION_NOTIFICATION_MASK	= 0x82,
	NVME_FEATURE_ID_RESERVATION_PERSISTANCE			= 0x83,

} NVME_FEATURE_ID_E;



// Status Code

typedef enum _NVME_STATUS_CODE_TYPE_E
{
	NVME_STATUS_CODE_TYPE_GENERIC					= 0x00,
	NVME_STATUS_CODE_TYPE_SPECIFIC					= 0x01,
	NVME_STATUS_CODE_TYPE_INTEGRITY					= 0x02,
	NVME_STATUS_CODE_TYPE_VENDOR					= 0x07,
} NVME_STATUS_CODE_TYPE_E;


// Status Code
typedef enum _NVME_SC_GENERIC_E
{
	NVME_SC_GENERIC_SUCCESS							= 0x00,
	NVME_SC_GENERIC_INVALID_COMMAND_OPCODE			= 0x01,
	NVME_SC_GENERIC_INVALID_FIELD_IN_COMMAND		= 0x02,
	NVME_SC_GENERIC_COMMAND_ID_CONFLICT				= 0x03,
	NVME_SC_GENERIC_DATA_TRANSFER_ERROR				= 0x04,
	NVME_SC_GENERIC_ABORTED_DUE_TO_POWER_LOSS		= 0x05,
	NVME_SC_GENERIC_INTERNAL_ERROR					= 0x06,
	NVME_SC_GENERIC_ABORT_REQUESTED					= 0x07,
	NVME_SC_GENERIC_ABORT_DUE_TO_SQ_DELETION		= 0x08,
	NVME_SC_GENERIC_ABORT_DUE_TO_FAIL_FUSE			= 0x09,
	NVME_SC_GENERIC_ABORT_DUE_TO_MISSING_FUSE		= 0x0A,
	NVME_SC_GENERIC_INVALID_NAMESPACE_OR_FORMAT		= 0x0B,
	NVME_SC_GENERIC_COMMAND_SEQUENCE_ERROR			= 0x0C,
	NVME_SC_GENERIC_INVALID_SGL_SEGMENT				= 0x0D,
	NVME_SC_GENERIC_INVALID_NUMBER_OF_SGL			= 0x0E,
	NVME_SC_GENERIC_DATA_SGL_LENGTH_INVALID			= 0x0F,
	NVME_SC_GENERIC_META_SGL_LENGTH_INVALID			= 0x10,
	NVME_SC_GENERIC_SGL_TYPE_INVALID				= 0x11,
	NVME_SC_GENERIC_INVALID_USE_OF_MEMORY			= 0x12,
	NVME_SC_GENERIC_PRP_OFFSET_INVALID				= 0x13,
	NVME_SC_GENERIC_ATOMIC_WRITE_UNIT_EXCEEDED		= 0x14,
	NVME_SC_GENERIC_OPERATION_DENIED				= 0x15,
	NVME_SC_GENERIC_SGL_OFFSET_INVALID				= 0x16,
	NVME_SC_GENERIC_HOST_ID_INVALID_FORMAT			= 0x18,
	NVME_SC_GENERIC_KEEP_ALIVE_TIME_EXPIRED			= 0x19,
	NVME_SC_GENERIC_KEEP_ALIVE_TIME_INVALID			= 0x1A,
	NVME_SC_GENERIC_ABORT_DUE_TO_PREEMPT			= 0x1B,
	NVME_SC_GENERIC_SANITIZE_FAILED					= 0x1C,
	NVME_SC_GENERIC_SANITIZE_IN_PROGRESS			= 0x1D,
	NVME_SC_GENERIC_SGL_DATA_BLOCK_INVALID			= 0x1E,
	NVME_SC_GENERIC_NOT_SUPPORTED_IN_CMB			= 0x1F,

	NVME_SC_GENERIC_LBA_OUT_OF_RANGE				= 0x80,
	NVME_SC_GENERIC_CAPACITY_EXCEEDED				= 0x81,
	NVME_SC_GENERIC_NAMESPACE_NOT_READY				= 0x82,
	NVME_SC_GENERIC_RESERVATION_CONFLICT			= 0x83,
	NVME_SC_GENERIC_FORMAT_IN_PROGRESS				= 0x84,
} NVME_SC_GENERIC_E;



// Status Code
typedef enum _NVME_SC_SPECIFIC_E
{
	NVME_SC_SPECIFIC_COMPLETION_QUEUE_INVALID		= 0x00,
	NVME_SC_SPECIFIC_INVALID_QUEUE_ID				= 0x01,
	NVME_SC_SPECIFIC_INVALID_QUEUE_SIZE				= 0x02,
	NVME_SC_SPECIFIC_ABORT_LIMIT_EXCEEDED			= 0x03,
	NVME_SC_SPECIFIC_ASYNC_LIMIT_EXCEEDED			= 0x05,
	NVME_SC_SPECIFIC_INVALID_FIRMWARE_SLOT			= 0x06,
	NVME_SC_SPECIFIC_INVALID_FIRMWARE_IMAGE			= 0x07,
	NVME_SC_SPECIFIC_INVALID_INTERRUPT_VECTOR		= 0x08,
	NVME_SC_SPECIFIC_INVALID_LOG_PAGE				= 0x09,
	NVME_SC_SPECIFIC_INVALID_FORMAT					= 0x0A,
	NVME_SC_SPECIFIC_FW_REQUIRE_CONVENTIONAL_RESET	= 0x0B,
	NVME_SC_SPECIFIC_INVALID_QUEUE_DELETION			= 0x0C,
	NVME_SC_SPECIFIC_FEATURE_NOT_SAVEABLE			= 0x0D,
	NVME_SC_SPECIFIC_FEATURE_NOT_CHANGEABLE			= 0x0E,
	NVME_SC_SPECIFIC_FEATURE_NOT_NAMESPACE			= 0x0F,
	NVME_SC_SPECIFIC_FW_REQUIRE_NVM_SUB_RESET		= 0x10,
	NVME_SC_SPECIFIC_FW_REQUIRE_RESET				= 0x11,
	NVME_SC_SPECIFIC_FW_REQUIRE_MAX_TIME_VIOLATION	= 0x12,
	NVME_SC_SPECIFIC_FW_ACTIVATION_PROHIBITED		= 0x13,
	NVME_SC_SPECIFIC_OVERLAPPING_RANGE				= 0x14,
	NVME_SC_SPECIFIC_NAMESPACE_OVER_CAPACITY		= 0x15,
	NVME_SC_SPECIFIC_NAMESPACE_ID_UNAVAILABLE		= 0x16,
	NVME_SC_SPECIFIC_NAMESPACE_ALREADY_ATTACHED		= 0x18,
	NVME_SC_SPECIFIC_NAMESPACE_IS_PRIVATE			= 0x19,
	NVME_SC_SPECIFIC_NAMESPACE_NOT_ATTACHED			= 0x1A,
	NVME_SC_SPECIFIC_THIN_PROVISION_NOT_SUPPORTED	= 0x1B,
	NVME_SC_SPECIFIC_CONTROLLER_LIST_INVALID		= 0x1C,
	NVME_SC_SPECIFIC_DEVICE_SELF_TEST_IN_PROGRESS	= 0x1D,
	NVME_SC_SPECIFIC_BOOT_PART_WRITE_PROHIBITED		= 0x1E,
	NVME_SC_SPECIFIC_INVALID_CONTROLLER_ID			= 0x1F,
	NVME_SC_SPECIFIC_INVALID_SECONDARY_CONTROLLER	= 0x20,
	NVME_SC_SPECIFIC_INVALID_NUMBER_OF_CONTROLLER	= 0x21,
	NVME_SC_SPECIFIC_INVALID_RESOURCE_ID			= 0x22,

	NVME_SC_SPECIFIC_CONFLICT_ATTRIBUTE				= 0x80,
	NVME_SC_SPECIFIC_INVALID_PROTECT_INFOMATION		= 0x81,
	NVME_SC_SPECIFIC_WRITE_TO_READ_ONLY_RANGE		= 0x82,
} NVME_SC_SPECIFIC_E;


// Status Code
typedef enum _NVME_SC_INTEGRITY_E
{
	NVME_SC_INTEGRITY_WRITE_FAULT					= 0x80,
	NVME_SC_INTEGRITY_UNRECOVERED_READ_ERROR		= 0x81,
	NVME_SC_INTEGRITY_END_TO_END_GUARD_ERROR		= 0x82,
	NVME_SC_INTEGRITY_END_TO_END_APP_TAG_ERROR		= 0x83,
	NVME_SC_INTEGRITY_END_TO_END_REFER_TAG_ERROR	= 0x84,
	NVME_SC_INTEGRITY_COMPARE_FAILURE				= 0x85,
	NVME_SC_INTEGRITY_ACCESS_DENIED					= 0x86,
	NVME_SC_INTEGRITY_UNWRITTEN_LOGICAL_BLOCK		= 0x87,

} NVME_SC_INTEGRITY_E;


typedef enum _NVME_LOG_PAGE_ID_E
{
	NVME_LOG_PAGE_ID_ERROR_INFORMATION					= 0x01,
	NVME_LOG_PAGE_ID_SMART_HEALTH_INFORMATION			= 0x02,
	NVME_LOG_PAGE_ID_FIRMWARE_SLOT_INFORMATION			= 0x03,
	NVME_LOG_PAGE_ID_CHANGED_NAMESPACE_LIST				= 0x04,
	NVME_LOG_PAGE_ID_COMMANDS_SUPPORTED_AND_EFFECTS		= 0x05,
	NVME_LOG_PAGE_ID_DEVICE_SELF_TEST					= 0x06,
	NVME_LOG_PAGE_ID_TELEMETRY_HOST_INITIATED			= 0x07,
	NVME_LOG_PAGE_ID_TELEMETRY_CONTROLLER_INITIATED		= 0x08,

	NVME_LOG_PAGE_ID_DISCOVERY							= 0x70,

	NVME_LOG_PAGE_ID_RESERVATION_NOTIFICATION			= 0x80,
	NVME_LOG_PAGE_ID_SANITIZE_STATUS					= 0x81,
} NVME_LOG_PAGE_ID_E;

typedef enum _NVME_SQ_IDENTIFY_CNS_E
{
	NVME_SQ_IDENTIFY_CNS_NAMESPACE_DATA						= 0x00,
	NVME_SQ_IDENTIFY_CNS_CONTOLLER_DATA						= 0x01,
	NVME_SQ_IDENTIFY_CNS_ACTIVE_NAMESPACE_LIST				= 0x02,
	NVME_SQ_IDENTIFY_CNS_NAMESPACE_IDENTIFICATION			= 0x03,
	NVME_SQ_IDENTIFY_CNS_NAMESPACE_ALLOCATED_LIST			= 0x10,
	NVME_SQ_IDENTIFY_CNS_NAMESPACE_DATA_STRUCTURE			= 0x11,
	NVME_SQ_IDENTIFY_CNS_CONTROLLER_LIST_NAMESPACE_ATTACHED = 0x12,
	NVME_SQ_IDENTIFY_CNS_CONTROLLER_LIST_ALL				= 0x13,
	NVME_SQ_IDENTIFY_CNS_CONTROLLER_PRIMARY_CAPABILTIES		= 0x14,
	NVME_SQ_IDENTIFY_CNS_CONTROLLER_SECONDARY_LIST			= 0x15,
} NVME_SQ_IDENTIFY_CNS_E;

#endif	// __NVME_STRUCTS_H__
