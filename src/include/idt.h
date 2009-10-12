#ifndef _IDT_H_
#define _IDT_H_

#include <stdint.h>


#define NUM_IDT_ENTRIES (256)



typedef struct
{
	uint32_t dl, dh;
} interrupt_descriptor_t;

typedef struct
{
	interrupt_descriptor_t descriptors[NUM_IDT_ENTRIES];
} idt_t;



void idt_init(void);
void dump_idt(void);


#endif /* _IDT_H_ */
