/*
 * ExceptionHandlers.c
 *
 *  Created on: 2 sty 2022
 *      Author: zaquadnik
 */

#include "ExceptionHandlers.h"

__attribute__((interrupt("UNDEF"), naked)) void UndefinedHandler (void)
{
	while(1);
}

 __attribute__((interrupt("PABT"), naked)) void PrefetchAbortHandler (void)
{
	while(1);
}

 __attribute__((interrupt("DABT"), naked)) void DataAbortHandler (void)
{
	while(1);
}

