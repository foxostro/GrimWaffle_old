#include <idt.h>
#include <asm.h>
#include <assert.h>

extern void printf(const char *format, ...);

static idt_t idt;


/* Prints the contents of the IDT and other debugging informtation */
void dump_idt(void)
{
	unsigned i;

	/* dump the GDT for our inspection */
	for(i=0; i<NUM_IDT_ENTRIES; ++i)
	{
		printf("idt[%d] = { dl=0x%x, dh=0x%x }\n",
		       i,
			   idt.descriptors[i].dl,
			   idt.descriptors[i].dh);
	}

	printf("idt limit = %x\n", sizeof(idt)-1);
}


/* Intializes a blank IDT and install it. No ISRs are initially specified! */
void idt_init(void)
{
	unsigned i;

	/* Clear out all descriptors */
	for(i=0; i<NUM_IDT_ENTRIES; ++i)
	{
		idt.descriptors[i].dl = 0;
		idt.descriptors[i].dh = 0;
	}

	/* Actually install the IDT here */
	lidt(&idt, sizeof(idt)-1);
}

