#include "stm8s003.h"
#include "clock.h"

void uart_write_c(unsigned char c)
{
	while(!(USART1_SR & USART_SR_TXE));
	USART1_DR = c;
}

void uart_write(const char *str)
{
	while(*str)
	{
		uart_write_c(*str);
		str++;
	}
}

void uart_read_c(unsigned char *c)
{
	while (!(USART1_SR & USART_SR_RXNE));    // USART_SR[5]:RXNE   Read data register not empty
//	PD_ODR |= (1<<2);                                      //   0: Data is not received, 1: Received data is ready to be read.
	*c = USART1_DR;
}

void uart_read(unsigned char *buf, unsigned char len)
{
	unsigned char	i;

	i = 0;
	while (!(USART1_SR & USART_SR_IDLE) && i < len)
	{
		uart_read_c(buf + i);
		i++;
	}
	buf[i] = '\0';
}

void delay_ms(unsigned long ms)
{
	unsigned long cycles = 960 * ms;
	while(cycles--);
}

int main(void)
{
//	int		i;
	unsigned char	buf[20] = {0};
	CLK_CKDIVR = 0x00;
	CLK_PCKENR1 = 0xFF; // Enable peripherals

	//PC_DDR = 0x08; // Put TX line on
	//PC_CR1 = 0x08;

	USART1_CR2 |= USART_CR2_TEN; // Allow TX & RX
	USART1_CR2 |= USART_CR2_REN; // Allow TX & RX
	USART1_CR3 &= ~(USART_CR3_STOP1 | USART_CR3_STOP2); // 1 stop bit
	USART1_BRR2 = 0x03; USART1_BRR1 = 0x68; // 9600 baud@16MHz CLK
	
	while(1)
	{

		if (!(USART1_SR & USART_SR_RXNE))
		{
			uart_read((unsigned char *) buf, 20);
			uart_write((unsigned char *) buf);
		}
//		uart_write((unsigned char*) buf);
		uart_write("Hello World!\n");
		delay_ms(1000);	
	}
}
