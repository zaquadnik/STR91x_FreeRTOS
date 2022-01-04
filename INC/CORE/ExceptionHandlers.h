/*
 * ExceptionHandlers.h
 *
 *  Created on: 2 sty 2022
 *      Author: zaquadnik
 */

#ifndef INC_CORE_EXCEPTIONHANDLERS_H_
#define INC_CORE_EXCEPTIONHANDLERS_H_

void UndefinedHandler (void) __attribute__((interrupt("UNDEF"), naked));

void PrefetchAbortHandler (void) __attribute__((interrupt("PABT"), naked));

void DataAbortHandler (void) __attribute__((interrupt("DABT"), naked));


#endif /* INC_CORE_EXCEPTIONHANDLERS_H_ */
