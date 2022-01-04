/*
 * ExceptionHandlers.c
 *
 *  Created on: 2 sty 2022
 *      Author: zaquadnik
 */

void UndefinedHandler (void) __attribute__((interrupt("UNDEF"), naked))
{
	while(1);
}

void PrefetchAbortHandler (void) __attribute__((interrupt("PABT"), naked))
{
	while(1);
}

void DataAbortHandler (void) __attribute__((interrupt("DABT"), naked))
{
	while(1);
}

