/** @file x86/asm.h
 *  @brief x86-specific assembly functions
 *  @author matthewj S2008 (15410)
 */

#ifndef X86_ASM_H
#define X86_ASM_H

#include <stdint.h>

/** @brief Loads a new gdt */
void lgdt(void *gdt, unsigned int limit);
/** @brief Loads a new idt */
void lidt(void *idt, unsigned int limit);
/** @brief Read address of IDD */
void *idt_base(void);

/** @brief Disables interrupts */
void disable_interrupts();
/** @brief Enables interrupts */
void enable_interrupts();

/** @brief Read from the TSC */
uint64_t rdtsc();

/** @brief Reads 1 byte from given port */
uint8_t inb(uint16_t port);
/** @brief Reads 2 bytes from given port */
uint16_t inw(uint16_t port);
/** @brief Reads 4 bytes from given port */
uint32_t ind(uint16_t port);

/** @brief Writes 1 byte to target port */
void outb(uint16_t port, uint8_t val);
/** @brief Writes 2 bytes to target port */
void outw(uint16_t port, uint16_t val);
/** @brief Writes 4 bytes to target port */
void outd(uint16_t port, uint32_t val);

/* Andrew Fox: So we can set the task register on boot, in C */
void ltr(unsigned int segsel_tss);

#endif /* !X86_ASM_H */
