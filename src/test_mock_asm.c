/* When building unit tests, some low-level assembly functions must be mocked
 * out. The mocks are defined in this file.
 * Example: We can't set the location of the GDT from a user-space test.
 */

void ltr(unsigned int segsel_tss) { }
void lgdt(void *gdt, unsigned int limit) { }
void lidt(void *idt, unsigned int limit) { }

