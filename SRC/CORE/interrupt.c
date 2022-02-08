/*
 * interrupt.c
 *
 *  Created on: 9 sty 2022
 *      Author: zaquadnik
 */

#include "interrupt.h"

status_t IrqRegister(
		void* IrqHandler,
		u16 Priority,
		IrqSource_t Source)
{

	if(IrqHandler == NULL)
	{
		return NULL_POINTER;
	}

	if((Priority > MAX_PRIORITY) ||
	   (Source > IRQ_LAST))
	{
		return INVALID_DATA;
	}

    if (Source < VIC_REGISTER_NUMBER) /* VIC0 */
    	VIC0->VAiR[Priority] = (u32)IrqHandler;
    else /* VIC1 */
    	VIC1->VAiR[Priority] = (u32)IrqHandler;

    VIC_ITCmd(Source,
    		  ENABLE);



	return OK;
}
