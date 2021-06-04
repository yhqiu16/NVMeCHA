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

//////////////////////////////////////////////////////////////////////////////////
// NVMe Specification parameters
//////////////////////////////////////////////////////////////////////////////////

// memory page size maximux/minimum
`define MPSMAX        (4'hc)
`define MPSMIN        (4'h0)
`define TIMEOUT       (8'h14)
// Maximum Queue Entries Supported for IO Queue
`define MAX_QSIZE     (16'h3ff)
// Maximum IO Queues
`define MAX_QID       (16'h10)
// Maximum MSI/MSIX Messages
`define MAX_MSI_MSG   (16'h10)

// OCSSD Version
`define VERSION       (8'h2)
// Wear-level Index Delta Threshold
`define WIT           (8'h2)

// Geometry related
// Number of Groups
`define NUM_GRP    (16'd4)
// Number of Parallel Units per Group, (Ways)
`define NUM_PU     (16'd4)
// Number of Chuncks per Parallel Unit, (Number of Blocks per Plane)
`define NUM_CHK    (32'd1048)
// Number of Logical Blocks per Chunck, (Logical Block size 4KiB)
`define NUM_LBLK   (32'd4096)
// LBA format
`define LBA_FMT    (64'h0c0b0202)

// Logical Block size bitwidth
`define LBADS_WIDTH   (8'hc)

// Identify Namespace data structure
// LBA_SIZE = NUM_GRP * NUM_PU * NUM_CHK * NUM_LBLK
`define NS_LBA_SIZE   (64'h4180000)
// Formatted LBA Size
`define NS_FLBAS      (8'h0)
// Metadata Capabilities 
`define NS_MC         (8'h3)
// End-to-End Data Protection Capabilities
`define NS_DPC        (8'h0)
// End-to-End Data Protection Type Settings
`define NS_DPS        (8'h0)
// ...
// LBA Format 0 Support
`define NS_LBAF0      (32'h0c0000)

// Identify Controller data structure
// Firmware Version, 2020-09 \0
`define NS_FR         (64'h32303230303900)
// IEEE OUI Identifier
`define NS_IEEE       (24'hAEBEAF)
// Maximum Data Transfer Size, 4KB * 2 ^ (MPSMIN + NS_MDTS)
`define NS_MDTS       (8'hF)



// Write Data Requirements
// Minmum Write Size, Min number of logical blocks to write per command within a chunck
`define WS_MIN     (32'd8)
// Optimal Write Size, Optimal number of logical blocks to write per command within a chunck
`define WS_OPT     (32'd24)
// Cache Minmum Write Size Units, number of logical blocks must have been written before the logical block to be read in a chunck
`define MW_CUNITS  (32'd0)
// Maximum Open Chuncks, Max number open chuncks at a time, 0 indicates all available chuncks
`define MAXOC      (32'd0)
// Maximum Open Chuncks, Max number open chuncks per PU at a time, 0 indicates all available chuncks
`define MAXOCPU    (32'd0)


// Performance related metrics
// Typical/Max time to read/write a write unit(ns)
// or Typical/Max chunck reset time(ns)
`define TRDT     (32'd50000)
`define TRDM     (32'd115000)
`define TWRT     (32'd1600000)
`define TWRM     (32'd3000000)
`define TCRST    (32'd3000000)
`define TCRSM    (32'd12000000)



// NVMe Command Set OPC
// delete IO SQ
`define NVME_DELETE_SQ         (8'h00)
// create IO SQ
`define NVME_CREATE_SQ         (8'h01)
// Get log page
`define NVME_GET_LOG_PGAE      (8'h02)
// delete IO CQ
`define NVME_DELETE_CQ         (8'h04)
// create IO CQ
`define NVME_CREATE_CQ         (8'h05)
// Identify
`define NVME_IDENTIFY          (8'h06)
// Abort
`define NVME_ABORT             (8'h08)
// Set Features
`define NVME_SET_FEATURE       (8'h09)
// Get Features
`define NVME_GET_FEATURE       (8'h0A)
// Asynchronous Event Requet
`define NVME_ASYN_EVENT_REQ    (8'h0C)
// Get geometry
`define NVME_GET_GEOMETRY      (8'hE2)

// IO Command
// Flush
`define NVME_FLUSH              (8'h00)
// Write
`define NVME_WRITE              (8'h01)
// Read
`define NVME_READ               (8'h02)


// DMA Transfer data size
`define DMA_TRAN_SIZE  4096