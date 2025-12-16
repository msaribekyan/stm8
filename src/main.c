#include "stm8s003.h"
#include "clock.h"

void uart_write(const char *str)
{
	while(*str)
	{
		while(!(USART1_SR & USART_SR_TXE));
		USART1_DR = *str;
		str++;
	}
}

void delay_ms(unsigned long ms)
{
	unsigned long cycles = 960 * ms;
	while(cycles--);
}

int main(void)
{
	CLK_CKDIVR = 0x00;
	CLK_PCKENR1 = 0xFF; // Enable peripherals

	//PC_DDR = 0x08; // Put TX line on
	//PC_CR1 = 0x08;

	USART1_CR2 = USART_CR2_TEN; // Allow TX & RX
	USART1_CR3 &= ~(USART_CR3_STOP1 | USART_CR3_STOP2); // 1 stop bit
	USART1_BRR2 = 0x03; USART1_BRR1 = 0x68; // 9600 baud@16MHz CLK
	
	while(1)
	{
		uart_write("Hello World!\n");
		delay_ms(1000);	
	}
}
