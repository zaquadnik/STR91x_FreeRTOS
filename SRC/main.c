/*
 * main.c
 *
 *  Created on: 2010-02-07
 *      Author: Zaquadnik_AJ
 */

#include "config.h"
#include "sysclk.h"
#include "console.h"
#include "heartbeat.h"

int main(void)
{
	status_t status;

	status = ScInitPll();
	if (OK != status)
	{
		//TODO: Error Handling
	}

	status = HbInitHeartBeat();
	status = InitConsole();

	while(1){

	}
	return 0;
}
