/*
 * sysclk.c
 *
 *  Created on: 2 mar 2025
 *      Author: Lenovo
 */

#include "CommonTypes.h"
#include "Config.h"
#include "91x_map.h"
#include "91x_scu.h"

#define PLL_N 192
#define PLL_M 24
#define PLL_P 2

status_t ScInitPll(void)
{
	status_t Status = OK;

	Status = ConvertStatus(SCU_PLLFactorsConfig(PLL_N, PLL_M, PLL_P));
	if (OK == Status)
	{
		Status = ConvertStatus(SCU_MCLKSourceConfig(SCU_MCLK_PLL));
	}

	return Status;
}

