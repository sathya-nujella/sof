// SPDX-License-Identifier: BSD-3-Clause
//
// Copyright(c) 2019 Intel Corporation. All rights reserved.
//
// Author: Tomasz Lauda <tomasz.lauda@linux.intel.com>

#include <sof/debug/panic.h>
#include <sof/lib/alloc.h>
#include <sof/spinlock.h>
#include <ipc/topology.h>

void arch_spinlock_init(spinlock_t **lock)
{
	*lock = rzalloc(RZONE_SYS | RZONE_FLAG_UNCACHED, SOF_MEM_CAPS_RAM,
			sizeof(**lock));

	assert(*lock);
}
