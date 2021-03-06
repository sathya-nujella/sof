// SPDX-License-Identifier: BSD-3-Clause
//
// Copyright(c) 2018 Intel Corporation. All rights reserved.
//
// Author: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
//         Liam Girdwood <liam.r.girdwood@linux.intel.com>
//         Keyon Jie <yang.jie@linux.intel.com>
//         Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

#include <sof/lib/alloc.h>
#include <sof/drivers/ipc.h>
#include <stdlib.h>

/* testbench ipc */
struct ipc *_ipc;

/* private data for IPC */
struct ipc_data {
	struct ipc_data_host_buffer dh_buffer;
};

int platform_ipc_init(struct ipc *ipc)
{
	struct ipc_data *iipc;

	_ipc = ipc;

	/* init ipc data */
	iipc = malloc(sizeof(struct ipc_data));
	ipc_set_drvdata(_ipc, iipc);

	/* allocate page table buffer */
	iipc->dh_buffer.page_table = malloc(HOST_PAGE_SIZE);
	if (iipc->dh_buffer.page_table)
		bzero(iipc->dh_buffer.page_table, HOST_PAGE_SIZE);

	return 0;
}

/* The following definitions are to satisfy libsof linker errors */

int ipc_stream_send_position(struct comp_dev *cdev,
			     struct sof_ipc_stream_posn *posn)
{
	return 0;
}

int ipc_stream_send_xrun(struct comp_dev *cdev,
			 struct sof_ipc_stream_posn *posn)
{
	return 0;
}
